//
//  DogEmotionClassficationEnvironment.swift
//  Just-Puppy
//
//  Created by Doyoung Song on 10/15/23.
//

import ComposableArchitecture
import CoreML
import UIKit

struct DogEmotionClassficationEnvironment {
    
    var prediction: (UIImage) -> Prediction
}

extension DogEmotionClassficationEnvironment: DependencyKey {
    
    static var liveValue = Self(prediction: { image in
        let configuration = MLModelConfiguration()
        guard let classifier = try? DogEmotionClassifier(configuration: configuration),
              let cvPixelBufferImage = image.toCVPixelBuffer(),
              let output = try? classifier.prediction(image: cvPixelBufferImage),
              let prediction = Prediction(rawValue: output.classLabel) else { return .none }
        return prediction
    })
}

extension DogEmotionClassficationEnvironment {
    
    enum Prediction: String {
        case happy
        case angry
        case relaxed
        case sad
        case none
    }
}

extension DependencyValues {
    
    var dogEmotionClassificationEnvironment: DogEmotionClassficationEnvironment {
        get { self[DogEmotionClassficationEnvironment.self] }
        set { self[DogEmotionClassficationEnvironment.self] = newValue }
    }
}
