//
//  AnalysisReducer.swift
//  Just-Puppy
//
//  Created by Doyoung Song on 10/15/23.
//

import ComposableArchitecture
import Foundation

struct AnalysisReducer: Reducer {
    
    struct State: Equatable {
        let analysis: Analysis?
    }
    
    enum Action {
        case deleteAnalysis
        case saveAnalysis
    }
    
    var body: some ReducerOf<AnalysisReducer> {
        Reduce { state, action in
            switch action {
            case .deleteAnalysis:
                NotificationCenter.default.post(name: .goToRoot, object: nil)
                return .none
            case .saveAnalysis:
                NotificationCenter.default.post(name: .goToRoot, object: nil)
                return .none
            }
        }
    }
}
