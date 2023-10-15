//
//  AnalysisReducer.swift
//  Just-Puppy
//
//  Created by Doyoung Song on 10/15/23.
//

import ComposableArchitecture

struct AnalysisReducer: Reducer {
    
    struct State: Equatable {
        let analysis: Analysis?
    }
    
    enum Action {
        
    }
    
    var body: some ReducerOf<AnalysisReducer> {
        Reduce { state, action in
            switch action {
            default:
                return .none
            }
        }
    }
}
