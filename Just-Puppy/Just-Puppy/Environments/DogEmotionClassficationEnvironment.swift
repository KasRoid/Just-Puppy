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
    
    var analysis: (UIImage) -> Analysis?
}

extension DogEmotionClassficationEnvironment: DependencyKey {
    
    static var liveValue = Self(analysis: { image in
        let configuration = MLModelConfiguration()
        guard let classifier = try? DogEmotionClassifier(configuration: configuration),
              let cvPixelBufferImage = image.toCVPixelBuffer(),
              let output = try? classifier.prediction(image: cvPixelBufferImage),
              let emotion = Emotion(rawValue: output.classLabel) else { return nil }
        let probabilities = output.classLabelProbs
        return Analysis(image: image, emotion: emotion, probabilities: probabilities)
    })
}

extension DependencyValues {
    
    var dogEmotionClassificationEnvironment: DogEmotionClassficationEnvironment {
        get { self[DogEmotionClassficationEnvironment.self] }
        set { self[DogEmotionClassficationEnvironment.self] = newValue }
    }
}
