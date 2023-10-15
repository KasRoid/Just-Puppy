//
//  Analysis.swift
//  Just-Puppy
//
//  Created by Doyoung Song on 10/15/23.
//

import UIKit

struct Analysis: Hashable {
    let image: UIImage
    let emotion: Emotion
    let probabilities: [String: Double]
    let date = Date()
}
