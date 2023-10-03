//
//  ContentReducer.swift
//  Just-Puppy
//
//  Created by Doyoung Song on 10/2/23.
//

import AVFoundation
import ComposableArchitecture
import UIKit

struct ContentReducer: Reducer {

    @Dependency(\.cameraAuthorizationEnvironment) var cameraEnvironment
    
    struct State: Equatable {
        var initialized = false
        var selectedTab: JPTab = .home
        var isCameraLoading = false
        var isCameraPresented = false
        var capturedImage: UIImage?
        var alertMessage: String?
    }
    
    enum Action {
        case initialize
        case checkCameraAuthorization
        case showCameraAuthRequest
        case showCameraLoading
        case hideCameraLoading
        case showCamera
        case hideCamera
        case showAlert(message: String)
        case hideAlert
        case select(tab: JPTab)
    }
    
    var body: some ReducerOf<ContentReducer> {
        Reduce { state, action in
            switch action {
            case .initialize:
                state.initialized = true
                return .none
            case .checkCameraAuthorization:
                return cameraAuthCheckEffect
            case .showCameraAuthRequest:
                return cameraAuthRequestEffect
            case .showCameraLoading:
                state.isCameraLoading = true
                return .none
            case .hideCameraLoading:
                state.isCameraLoading = false
                return .none
            case .showCamera:
                state.isCameraPresented = true
                return .none
            case .hideCamera:
                state.isCameraPresented = false
                return .none
            case .showAlert(let message):
                state.alertMessage = message
                return .none
            case .hideAlert:
                state.alertMessage = nil
                return .none
            case .select(let tab):
                state.selectedTab = tab
                return .none
            }
        }
    }
}

// MARK: - Effects
extension ContentReducer {
    
    private var cameraAuthCheckEffect: Effect<Action> {
        return .run { send in
            switch cameraEnvironment.event {
            case .authorized:
                await send(.showCameraLoading)
                await send(.showCamera)
            case .authorizationRequired:
                await send(.showCameraAuthRequest)
            case .alert(let message):
                await send(.showAlert(message: message))
            }
        }
    }
    
    private var cameraAuthRequestEffect: Effect<Action> {
        return .run { send in
            guard await AVCaptureDevice.requestAccess(for: .video) else { return }
            await send(.showCameraLoading)
            await send(.showCamera)
        }
    }
}
