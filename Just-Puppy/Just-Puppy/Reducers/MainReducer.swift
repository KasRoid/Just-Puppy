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
        var selectedAnalysis: Analysis?
        var isAnalysisPresented = false
    }
    
    enum Action {
        case loadAnalyses
        case showAlbum
        case showDetail(Analysis)
        case hideDetail
    }
    
    var body: some ReducerOf<MainReducer> {
        Reduce { state, action in
            switch action {
            case .loadAnalyses:
                let analyses = fileLoadingEnvironment.analyses ?? []
                state.analyses = analyses
                return .none
            case .showDetail(let analysis):
                state.selectedAnalysis = analysis
                state.isAnalysisPresented = true
                return .none
            case .hideDetail:
                state.isAnalysisPresented = false
                return .none
            default:
                return .none
            }
        }
    }
}
