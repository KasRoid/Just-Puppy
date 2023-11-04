//
//  StatisticsReducer.swift
//  Just-Puppy
//
//  Created by Doyoung Song on 11/4/23.
//

import ComposableArchitecture
import Foundation
import OrderedCollections

struct StatisticsReducer: Reducer {
    
    struct State: Equatable {
        var analyses: OrderedDictionary<Emotion, [Analysis]>
        
        init() {
            var analyses: OrderedDictionary<Emotion, [Analysis]> = [:]
            for emotion in Emotion.allCases {
                analyses[emotion] = AnalysisManager.shared.analyses.filter { $0.emotion == emotion }
            }
            self.analyses = analyses
        }
    }
    
    enum Action {
        
    }

    var body: some ReducerOf<StatisticsReducer> {
        Reduce { state, action in
            return .none
        }
    }
}
