//
//  PhotoReviewReducer.swift
//  Just-Puppy
//
//  Created by Doyoung Song on 10/15/23.
//

import ComposableArchitecture
import UIKit

struct PhotoReviewReducer: Reducer {
    
    @Dependency(\.dogEmotionClassificationEnvironment) var dogEmotionClassificationEnvironment
    
    struct State: Equatable {
        var capturedImage: UIImage
        var analysis: Analysis?
        var isAnalysisPresented = false
    }
    
    enum Action {
        case analyze
        case showAnalysis(Analysis?)
        case hideAnalysis
    }
    
    var body: some ReducerOf<PhotoReviewReducer> {
        Reduce { state, action in
            switch action {
            case .analyze:
                let image = state.capturedImage
                return dogClassificationEffect(with: image)
            case .showAnalysis(let analysis):
                state.analysis = analysis
                state.isAnalysisPresented = true
                return .none
            case .hideAnalysis:
                return .none
            }
        }
    }
}

// MARK: - Private Functions
extension PhotoReviewReducer {
    
    private func dogClassificationEffect(with image: UIImage) -> Effect<Action> {
        return .run { send in
            let analysis = dogEmotionClassificationEnvironment.analysis(image)
            await send(.showAnalysis(analysis))
        }
    }
}
