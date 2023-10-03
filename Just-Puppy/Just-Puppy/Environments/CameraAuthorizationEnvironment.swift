//
//  CameraAuthorizationEnvironment.swift
//  Just-Puppy
//
//  Created by Doyoung Song on 10/3/23.
//

import AVFoundation
import ComposableArchitecture

struct CameraAuthorizationEnvironment {
    
    var event: Event
}

extension CameraAuthorizationEnvironment: DependencyKey {
    
    static var liveValue: CameraAuthorizationEnvironment {
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

extension CameraAuthorizationEnvironment {
    
    enum Event {
        case alert(message: String)
        case authorizationRequired
        case authorized
    }
}

extension DependencyValues {
    
    var cameraAuthorizationEnvironment: CameraAuthorizationEnvironment {
        get { self[CameraAuthorizationEnvironment.self] }
    }
}
