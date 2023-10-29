//
//  AnalysisReducer.swift
//  Just-Puppy
//
//  Created by Doyoung Song on 10/15/23.
//

import ComposableArchitecture
import Foundation

struct AnalysisReducer: Reducer {
    
    @Dependency(\.fileSavingEnvironment) var fileSavingEnvironment
    @Dependency(\.fileDeletionEnvironment) var fileDeletionEnvironment
    
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
                let event = fileDeletionEnvironment.analysis(analysis)
                switch event {
                case .success:
                    NotificationCenter.default.post(name: .changesInFiles, object: nil)
                    return .run {
                        await $0(.goToRoot)
                    }
                case .failure(let error):
                    print(error)
                    return .none
                }
            case .saveAnalysis:
                let analysis = state.analysis!
                let event = fileSavingEnvironment.analysis(analysis)
                switch event {
                case .success:
                    NotificationCenter.default.post(name: .changesInFiles, object: nil)
                    return .run {
                        await $0(.goToRoot)
                    }
                case .failure(let error):
                    print(error)
                    return .none
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
