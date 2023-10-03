//
//  MainReducer.swift
//  Just-Puppy
//
//  Created by Doyoung Song on 10/1/23.
//

import ComposableArchitecture

struct MainReducer: Reducer {
    
    struct State: Equatable {
        var histories: [String] = []
    }
    
    enum Action {
        case showAlbum
        case showDetail
    }
    
    var body: some ReducerOf<MainReducer> {
        Reduce { state, action in
            switch action {
            default:
                return .none
            }
        }
    }
}
