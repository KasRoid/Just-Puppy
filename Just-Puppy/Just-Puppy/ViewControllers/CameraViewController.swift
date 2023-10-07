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
    
    private let captureSession = AVCaptureSession()
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
        bindViewStore()
        bindUI()
        setupVideoDataOutput()
        startCaptureSession()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        previewContainerView.layer.sublayers?.first?.frame = previewContainerView.bounds
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
            .sink { [weak self] _ in self?.viewStore.send(.takePhoto) }
            .store(in: &cancellables)
    }
    
    private func bindViewStore() {
        viewStore.publisher.position
            .sink { [weak self] in self?.setupInputs(position: $0) }
            .store(in: &cancellables)
    }
}

// MARK: - Capture Related
extension CameraViewController {
    
    private func startCaptureSession() {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self else { return }
            captureSession.beginConfiguration()
            captureSession.sessionPreset = .photo
            captureSession.automaticallyConfiguresCaptureDeviceForWideColor = true
            captureSession.commitConfiguration()
            captureSession.startRunning()
        }
    }
    
    private func setupInputs(position: AVCaptureDevice.Position) {
        guard let captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: position) else { return }
        captureSession.inputs.forEach { captureSession.removeInput($0) }
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            guard captureSession.canAddInput(input) else { return }
            captureSession.addInput(input)
        } catch {
            print(error)
        }
    }
    
    private func setupVideoDataOutput() {
        let dataOutput = AVCaptureVideoDataOutput()
        let videoQueue = DispatchQueue(label: "videoQueue", qos: .userInteractive)
        dataOutput.setSampleBufferDelegate(self, queue: videoQueue)
        guard captureSession.canAddOutput(dataOutput) else { return }
        captureSession.addOutput(dataOutput)
    }
    
    private func stopCaptureSession() {
        guard captureSession.isRunning else { return }
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.captureSession.stopRunning()
        }
    }
}

// MARK: - AVCaptureVideoDataOutputSampleBufferDelegate
extension CameraViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard viewStore.state.isTakingPhoto,
              let cvImageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        let ciImage = CIImage(cvImageBuffer: cvImageBuffer)
        let uiImage = UIImage(ciImage: ciImage)
        
        DispatchQueue.main.async { [weak self] in
            self?.viewStore.send(.capture(image: uiImage))
        }
    }
}

// MARK: - UI
extension CameraViewController {
    
    private func setupUI() {
        setupPreviewLayer()
        setupCancelButton()
        setupCaptureButton()
    }
    
    private func setupPreviewLayer() {
        view.addSubview(previewContainerView)
        previewContainerView.translatesAutoresizingMaskIntoConstraints = false
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewContainerView.layer.insertSublayer(previewLayer, below: previewContainerView.layer)
        previewLayer.frame = previewContainerView.layer.frame
        previewLayer.videoGravity = .resizeAspectFill
        
        NSLayoutConstraint.activate([
            previewContainerView.topAnchor.constraint(equalTo: view.topAnchor),
            previewContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            previewContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            previewContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
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
