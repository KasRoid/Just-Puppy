//
//  FavoriteReducer.swift
//  Just-Puppy
//
//  Created by Doyoung Song on 10/29/23.
//

import ComposableArchitecture
import Foundation
import OrderedCollections

struct FavoriteReducer: Reducer {
    
    struct State: Equatable {
        var analyses: OrderedSet<Analysis>
        var selectedAnalysis: Analysis?
        var isAnalysisPresented = false
    }
    
    enum Action {
        case setAnalyses(OrderedSet<Analysis>)
        case showAlbum
        case toggleFavorite(Analysis)
        case showDetail(Analysis)
        case hideDetail
    }
    
    var body: some ReducerOf<FavoriteReducer> {
        Reduce { state, action in
            switch action {
            case .setAnalyses(let analyses):
                let favoriteAnalyses = analyses.filter(\.isFavorite)
                state.analyses = OrderedSet(favoriteAnalyses)
                return .none
            case .toggleFavorite(var analysis):
                let updatedAnalysis = analysis.update(isFavorite: !analysis.isFavorite)
                AnalysisManager.shared.saveAnalysis(updatedAnalysis)
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
