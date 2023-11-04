//
//  CameraViewController.swift
//  Just-Puppy
//
//  Created by Doyoung Song on 10/3/23.
//

import AVFoundation
import Combine
import ComposableArchitecture
import UIKit

final class CameraViewController: UIViewController {
    
    private let previewContainerView = UIView()
    private let cancelButton = UIButton()
    private let captureButton = UIButton()
    
    @Published private var captureSession: AVCaptureSession?
    private var photoOutput: AVCapturePhotoOutput?
    private let viewStore: ViewStore<CameraReducer.State, CameraReducer.Action>
    private let cancelAction: () -> Void
    private var cancellables = Set<AnyCancellable>()
    
    private var translucentView: UIView {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        return view
    }
    
    init(store: StoreOf<CameraReducer>, cancelAction: @escaping () -> Void) {
        viewStore = ViewStore(store, observe: { $0 })
        self.cancelAction = cancelAction
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindSession()
        bindViewStore()
        bindUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startCaptureSession()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopCaptureSession()
    }
}

// MARK: - Bindings
extension CameraViewController {
    
    private func bindUI() {
        cancelButton.publisher(for: .touchUpInside)
            .sink { [weak self] _ in self?.cancelAction() }
            .store(in: &cancellables)
        
        captureButton.publisher(for: .touchUpInside)
            .sink { [weak self] _ in self?.takePhoto() }
            .store(in: &cancellables)
    }
    
    private func bindViewStore() {
        Publishers.CombineLatest($captureSession, viewStore.publisher.position)
            .compactMap {
                guard let session = $0.0 else { return nil }
                let position = $0.1
                return (session, position)
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.setupInputs(with: $0, position: $1) }
            .store(in: &cancellables)
    }
    
    private func bindSession() {
        $captureSession
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                if let session = $0 {
                    self?.setupPhotoOutput(with: session)
                    self?.setupPreviewLayer(with: session)
                } else {
                    self?.previewContainerView.layer.sublayers?.removeAll()
                }
            }
            .store(in: &cancellables)
    }
}

// MARK: - Capture Related
extension CameraViewController {
    
    private func startCaptureSession() {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            let session = AVCaptureSession()
            session.beginConfiguration()
            session.sessionPreset = .photo
            session.automaticallyConfiguresCaptureDeviceForWideColor = true
            session.commitConfiguration()
            session.startRunning()
            self?.captureSession = session
        }
    }
    
    private func setupInputs(with session: AVCaptureSession, position: AVCaptureDevice.Position) {
        guard let captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: position) else { return }
        session.inputs.forEach(session.removeInput)
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            guard session.canAddInput(input) else { return }
            session.addInput(input)
        } catch {
            print(error)
        }
    }
    
    private func setupPhotoOutput(with session: AVCaptureSession) {
        let output = AVCapturePhotoOutput()
        session.outputs.forEach(session.removeOutput)
        guard session.canAddOutput(output) else { return }
        session.addOutput(output)
        photoOutput = output
    }
    
    private func stopCaptureSession() {
        guard let captureSession, captureSession.isRunning else { return }
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.captureSession?.stopRunning()
            self?.captureSession = nil
            self?.photoOutput = nil
        }
    }
    
    private func takePhoto() {
        let photoSetting = AVCapturePhotoSettings()
        if let photoPreviewType = photoSetting.availablePreviewPhotoPixelFormatTypes.first {
            photoSetting.previewPhotoFormat = [kCVPixelBufferPixelFormatTypeKey as String: photoPreviewType]
            photoOutput?.capturePhoto(with: photoSetting, delegate: self)
        }
    }
}

// MARK: - AVCaptureVideoDataOutputSampleBufferDelegate
extension CameraViewController: AVCapturePhotoCaptureDelegate {
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let cgImage = photo.cgImageRepresentation() else { return }
        let image = UIImage(cgImage: cgImage)
        let rotatedImage = UIImage(cgImage: cgImage, scale: image.scale, orientation: .right)
        guard let compressedData = rotatedImage.jpegData(compressionQuality: 0.1) else { return }
        let compressedImage = UIImage(data: compressedData)
        viewStore.send(.capture(image: compressedImage))
    }
}

// MARK: - UI
extension CameraViewController {
    
    private func setupUI() {
        setupPreviewContainerView()
        setupCancelButton()
        setupCaptureButton()
    }
    
    private func setupPreviewContainerView() {
        view.addSubview(previewContainerView)
        previewContainerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            previewContainerView.topAnchor.constraint(equalTo: view.topAnchor),
            previewContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            previewContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            previewContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupPreviewLayer(with session: AVCaptureSession) {
        previewContainerView.layer.sublayers?.removeAll()
        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewContainerView.layer.insertSublayer(previewLayer, below: previewContainerView.layer)
        previewLayer.frame = previewContainerView.layer.frame
        previewLayer.videoGravity = .resizeAspectFill
        previewContainerView.layer.sublayers?.first?.frame = previewContainerView.bounds
    }
    
    private func setupCancelButton() {
        let containerView = translucentView
        view.addSubview(containerView)
        containerView.addSubview(cancelButton)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        
        var configuration = UIButton.Configuration.plain()
        configuration.title = "Cancel"
        configuration.baseForegroundColor = .mainRed
        cancelButton.configuration = configuration
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: view.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 120),
            
            cancelButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor, constant: 20),
            cancelButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16)
        ])
    }
    
    private func setupCaptureButton() {
        let containerView = translucentView
        view.addSubview(containerView)
        containerView.addSubview(captureButton)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        captureButton.translatesAutoresizingMaskIntoConstraints = false
        
        var configuration = UIButton.Configuration.filled()
        configuration.cornerStyle = .capsule
        configuration.baseBackgroundColor = .mainRed
        configuration.image = UIImage(systemName: "pawprint.fill")
        captureButton.configuration = configuration
        
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 140),
            
            captureButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            captureButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor, constant: -16),
            captureButton.widthAnchor.constraint(equalToConstant: 60),
            captureButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
}
