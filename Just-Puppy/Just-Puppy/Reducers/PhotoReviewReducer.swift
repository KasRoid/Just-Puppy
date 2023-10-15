//
//  PhotoReviewReducer.swift
//  Just-Puppy
//
//  Created by Doyoung Song on 10/15/23.
//

import ComposableArchitecture
import UIKit

struct PhotoReviewReducer: Reducer {
    
    @Dependency(\.dogEmotionClassificationEnvironment) var dogClassificationEnvironment
    
    struct State: Equatable {
        var capturedImage: UIImage
    }
    
    enum Action {
        case analyze(UIImage)
    }
    
    var body: some ReducerOf<PhotoReviewReducer> {
        Reduce { state, action in
            switch action {
            case .analyze(let image):
                return dogClassificationEffect(with: image)
            }
        }
    }
}

// MARK: - Private Functions
extension PhotoReviewReducer {
    
    private func dogClassificationEffect(with image: UIImage) -> Effect<Action> {
        return .run { send in
            let prediction = dogClassificationEnvironment.prediction(image)
            switch prediction {
            case .happy:
                print("Happy")
            case .angry:
                print("Angry")
            case .relaxed:
                print("Relaxed")
            case .sad:
                print("Sad")
            case .none:
                print("None")
            }
        }
    }
}
