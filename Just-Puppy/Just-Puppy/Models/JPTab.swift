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
            return "Home"
        case .favorites:
            return "Favorites"
        case .statistics:
            return "Statistics"
        case .settings:
            return "Settings"
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
