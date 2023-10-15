//
//  PhotoReviewReducer.swift
//  Just-Puppy
//
//  Created by Doyoung Song on 10/15/23.
//

import ComposableArchitecture
import UIKit

struct PhotoReviewReducer: Reducer {
    
    struct State: Equatable {
        var capturedImage: UIImage
    }
    
    enum Action {
        case goBack
        case analyze
    }
    
    var body: some ReducerOf<PhotoReviewReducer> {
        Reduce { state, action in
            switch action {
            case .goBack:
                print("Back")
                return .none
            case .analyze:
                print("Analyze")
                return .none
            }
        }
    }
}
