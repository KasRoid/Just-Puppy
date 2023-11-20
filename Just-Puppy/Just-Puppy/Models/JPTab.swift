//
//  JPTab.swift
//  Just-Puppy
//
//  Created by Doyoung Song on 10/2/23.
//

enum JPTab {
    case home
    case favorites
    case statistics
    case settings
    
    var title: String {
        switch self {
        case .home:
            return String(localized: "Home")
        case .favorites:
            return String(localized: "Favorites")
        case .statistics:
            return String(localized: "Statistics")
        case .settings:
            return String(localized: "Settings")
        }
    }
    
    var imageName: String {
        switch self {
        case .home:
            return "pawprint.fill"
        case .favorites:
            return "star.fill"
        case .statistics:
            return "list.bullet"
        case .settings:
            return "gearshape.fill"
        }
    }
}
