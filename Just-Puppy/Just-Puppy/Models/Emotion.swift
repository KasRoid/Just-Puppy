//
//  Emotion.swift
//  Just-Puppy
//
//  Created by Doyoung Song on 10/15/23.
//

enum Emotion: String, CaseIterable, Codable {
    case happy
    case relaxed
    case sad
    case angry
    case none
    
    var title: String {
        switch self {
        case .happy:
            return String(localized: "Happy")
        case .relaxed:
            return String(localized: "Relaxed")
        case .sad:
            return String(localized: "Sad")
        case .angry:
            return String(localized: "Angry")
        case .none:
            return String(localized: "None")
        }
    }
}
