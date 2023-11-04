//
//  SettingsReducer.swift
//  Just-Puppy
//
//  Created by Doyoung Song on 11/4/23.
//

import ComposableArchitecture
import Foundation

struct SettingsReducer: Reducer {
    
    struct State: Equatable {}
    
    enum Action {
        case deleteAll
    }

    var body: some ReducerOf<SettingsReducer> {
        Reduce { state, action in
            switch action {
            case .deleteAll:
                AnalysisManager.shared.deleteAllAnalyses()
            }
            return .none
        }
    }
}
