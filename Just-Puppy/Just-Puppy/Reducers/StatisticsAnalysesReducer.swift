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
    }
    
    enum Action {
        case showDetail
    }
    
    var body: some ReducerOf<StatisticsAnalysesReducer> {
        Reduce { state, action in
            return .none
        }
    }
}
