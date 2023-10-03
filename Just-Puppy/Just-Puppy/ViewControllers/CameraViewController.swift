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
    
    private var previewLayer: AVCaptureVideoPreviewLayer?
    private let captureButton = UIButton(type: .system)
    
    private let captureSession = AVCaptureSession()
    private let viewStore: ViewStore<CameraReducer.State, CameraReducer.Action>
    private var cancellables = Set<AnyCancellable>()
    
    init(store: StoreOf<CameraReducer>) {
        viewStore = ViewStore(store, observe: { $0 })
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
}

// MARK: - Bindings
extension CameraViewController {
    
    private func bindUI() {
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
        setupCaptureButton()
    }
    
    private func setupPreviewLayer() {
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        guard let previewLayer else { return }
        view.layer.insertSublayer(previewLayer, below: view.layer)
        previewLayer.frame = view.layer.frame
    }
    
    private func setupCaptureButton() {
        view.addSubview(captureButton)
        captureButton.translatesAutoresizingMaskIntoConstraints = false
        captureButton.setTitle("Capture", for: .normal)
        
        NSLayoutConstraint.activate([
            captureButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            captureButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}
