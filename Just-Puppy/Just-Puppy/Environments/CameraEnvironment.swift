//
//  CameraEnvironment.swift
//  Just-Puppy
//
//  Created by Doyoung Song on 10/3/23.
//

import AVFoundation
import ComposableArchitecture

struct CameraEnvironment {
    
    var event: Event
}

extension CameraEnvironment: DependencyKey {
    
    static var liveValue: CameraEnvironment {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            return .init(event: .authorized)
        case .notDetermined:
            return .init(event: .authorizationRequired)
        case .denied:
            return .init(event: .alert(message: "Please change camera authorization status in settings"))
        case .restricted:
            return .init(event: .alert(message: "Your camera access is restricted"))
        @unknown default:
            fatalError()
        }
    }
}

extension CameraEnvironment {
    
    enum Event {
        case alert(message: String)
        case authorizationRequired
        case authorized
    }
}

extension DependencyValues {
    
    var cameraEnvironment: CameraEnvironment {
        get { self[CameraEnvironment.self] }
    }
}
