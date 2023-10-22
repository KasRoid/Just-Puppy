//
//  MainReducer.swift
//  Just-Puppy
//
//  Created by Doyoung Song on 10/1/23.
//

import ComposableArchitecture

struct MainReducer: Reducer {
    
    @Dependency(\.fileLoadingEnvironment) var fileLoadingEnvironment
    
    struct State: Equatable {
        var analyses: [Analysis] = []
    }
    
    enum Action {
        case loadAnalyses
        case showAlbum
        case showDetail
    }
    
    var body: some ReducerOf<MainReducer> {
        Reduce { state, action in
            switch action {
            case .loadAnalyses:
                let analyses = fileLoadingEnvironment.analyses ?? []
                state.analyses = analyses
                return .none
            default:
                return .none
            }
        }
    }
}
