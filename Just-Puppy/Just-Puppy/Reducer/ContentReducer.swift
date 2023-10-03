//
//  ContentReducer.swift
//  Just-Puppy
//
//  Created by Doyoung Song on 10/2/23.
//

import ComposableArchitecture
import UIKit

struct ContentReducer: Reducer {
    
    struct State: Equatable {
        var initialized = false
        var selectedTab: JPTab = .home
        var isCameraPresented = false
        var capturedImage: UIImage?
    }
    
    enum Action {
        case initialize
        case showCamera
        case hideCamera
        case select(tab: JPTab)
    }
    
    var body: some ReducerOf<ContentReducer> {
        Reduce { state, action in
            switch action {
            case .initialize:
                state.initialized = true
                return .none
            case .showCamera:
                state.isCameraPresented = true
                return .none
            case .hideCamera:
                state.isCameraPresented = false
                return .none
            case .select(let tab):
                state.selectedTab = tab
                return .none
            }
        }
    }
}
