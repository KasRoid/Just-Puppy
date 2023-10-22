//
//  Analysis.swift
//  Just-Puppy
//
//  Created by Doyoung Song on 10/15/23.
//

import UIKit

struct Analysis: Hashable, Codable {
    let image: UIImage
    let emotion: Emotion
    let probabilities: [String: Double]
    let date = Date()
    
    init(image: UIImage, emotion: Emotion, probabilities: [String: Double]) {
        self.image = image
        self.emotion = emotion
        self.probabilities = probabilities
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let imageData = try container.decode(Data.self, forKey: .image)
        guard let decodedImage = UIImage(data: imageData) else {
            throw DecodingError.dataCorruptedError(forKey: .image, in: container, debugDescription: "Invalid image data")
        }
        image = decodedImage
        emotion = try container.decode(Emotion.self, forKey: .emotion)
        probabilities = try container.decode([String: Double].self, forKey: .probabilities)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        let imageData = image.pngData()!
        try container.encode(imageData, forKey: .image)
        try container.encode(emotion, forKey: .emotion)
        try container.encode(probabilities, forKey: .probabilities)
    }
    
    enum CodingKeys: String, CodingKey {
        case image
        case emotion
        case probabilities
        case date
    }
}
