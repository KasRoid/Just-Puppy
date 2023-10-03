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
    
    private let cancelButton = UIButton()
    private let captureButton = UIButton()
    
    private let captureSession = AVCaptureSession()
    private let viewStore: ViewStore<CameraReducer.State, CameraReducer.Action>
    private let cancelAction: () -> Void
    private var cancellables = Set<AnyCancellable>()
    
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
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        view.layer.insertSublayer(previewLayer, below: view.layer)
        previewLayer.frame = view.layer.frame
    }
    
    private func setupCancelButton() {
        view.addSubview(cancelButton)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        var configuration = UIButton.Configuration.plain()
        configuration.title = "Cancel"
        configuration.baseForegroundColor = .mainRed
        cancelButton.configuration = configuration
        
        NSLayoutConstraint.activate([
            cancelButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
    }
    
    private func setupCaptureButton() {
        view.addSubview(captureButton)
        captureButton.translatesAutoresizingMaskIntoConstraints = false
        var configuration = UIButton.Configuration.filled()
        configuration.cornerStyle = .capsule
        configuration.baseBackgroundColor = .mainRed
        configuration.image = UIImage(systemName: "pawprint.fill")
        captureButton.configuration = configuration
        
        NSLayoutConstraint.activate([
            captureButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            captureButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            captureButton.widthAnchor.constraint(equalToConstant: 60),
            captureButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
}
