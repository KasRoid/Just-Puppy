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
        var selectedEmotion: Emotion?
        var isListPresented = false
        
        init() {
            var analyses: OrderedDictionary<Emotion, [Analysis]> = [:]
            for emotion in Emotion.allCases {
                analyses[emotion] = AnalysisManager.shared.analyses.filter { $0.emotion == emotion }
            }
            self.analyses = analyses
        }
    }
    
    enum Action {
        case showList(Emotion)
        case hideList
    }

    var body: some ReducerOf<StatisticsReducer> {
        Reduce { state, action in
            switch action {
            case .showList(let emotion):
                state.selectedEmotion = emotion
                state.isListPresented = !(state.analyses[emotion]?.isEmpty ?? true)
            case .hideList:
                state.isListPresented = false
                state.selectedEmotion = nil
            }
            return .none
        }
    }
}
