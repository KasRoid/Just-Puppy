//
//  StatisticsAnalysesReducer.swift
//  Just-Puppy
//
//  Created by Doyoung Song on 11/4/23.
//

import ComposableArchitecture
import Foundation

struct StatisticsAnalysesReducer: Reducer {
 
    struct State: Equatable {
        var emotion: Emotion
        var analyses: [Analysis]
        var selectedAnalysis: Analysis?
        var isDetailPresented = false
    }
    
    enum Action {
        case showDetail(Analysis)
        case hideDetail
    }
    
    var body: some ReducerOf<StatisticsAnalysesReducer> {
        Reduce { state, action in
            switch action {
            case .showDetail(let analysis):
                state.selectedAnalysis = analysis
                state.isDetailPresented = true
            case .hideDetail:
                state.selectedAnalysis = nil
                state.isDetailPresented = false
            }
            return .none
        }
    }
}
