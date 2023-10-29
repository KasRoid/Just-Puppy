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
        case goToRoot
        case showAlert
    }
    
    var body: some ReducerOf<AnalysisReducer> {
        Reduce { state, action in
            switch action {
            case .deleteAnalysis:
                let analysis = state.analysis!
                AnalysisManager.shared.deleteAnalysis(analysis)
                return .run {
                    await $0(.goToRoot)
                }
            case .saveAnalysis:
                let analysis = state.analysis!
                AnalysisManager.shared.saveAnalysis(analysis)
                return .run {
                    await $0(.goToRoot)
                }
            case .goToRoot:
                NotificationCenter.default.post(name: .goToRoot, object: nil)
                return .none
            case .showAlert:
                return .none
            }
        }
    }
}
