//
//  CameraReducer.swift
//  Just-Puppy
//
//  Created by Doyoung Song on 10/3/23.
//

import AVFoundation
import ComposableArchitecture
import UIKit

struct CameraReducer: Reducer {
    
    struct State: Equatable {
        var position: AVCaptureDevice.Position = .back
        var capturedImage: UIImage?
    }
    
    enum Action {
        case setCapturePosition(AVCaptureDevice.Position)
        case capture(image: UIImage?)
    }
    
    var body: some ReducerOf<CameraReducer> {
        Reduce { state, action in
            switch action {
            case .setCapturePosition(let position):
                state.position = position
                return .none
            case .capture(let image):
                state.capturedImage = image
                return .none
            }
        }
    }
}
