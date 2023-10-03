//
//  CameraCaptureEnvironment.swift
//  Just-Puppy
//
//  Created by Doyoung Song on 10/3/23.
//

import AVFoundation
import ComposableArchitecture

struct CameraCaptureEnvironment {
    
    var event: Event
}

extension CameraCaptureEnvironment: DependencyKey {
    
    static var liveValue: CameraCaptureEnvironment {
        return .init(event: .captured)
    }
}

extension CameraCaptureEnvironment {
    
    enum Event {
        case captured
    }
}

extension DependencyValues {
    
    var cameraCaptureEnvironment: CameraCaptureEnvironment {
        get { self[CameraCaptureEnvironment.self] }
    }
}
