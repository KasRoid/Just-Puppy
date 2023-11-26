//
//  Analysis.swift
//  Just-Puppy
//
//  Created by Doyoung Song on 10/15/23.
//

import UIKit

struct Analysis: Hashable, Equatable, Codable {
    let image: UIImage
    let emotion: Emotion
    let probabilities: [String: Double]
    let date: Date
    var isFavorite: Bool
    
    init(image: UIImage, emotion: Emotion, probabilities: [String: Double]) {
        self.image = image
        self.emotion = emotion
        self.probabilities = probabilities
        self.date = Date()
        self.isFavorite = false
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
        date = try container.decode(Date.self, forKey: .date)
        isFavorite = try container.decode(Bool.self, forKey: .isFavorite)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        print(image)
        let imageData = image.pngData()!
        try container.encode(imageData, forKey: .image)
        try container.encode(emotion, forKey: .emotion)
        try container.encode(probabilities, forKey: .probabilities)
        try container.encode(date, forKey: .date)
        try container.encode(isFavorite, forKey: .isFavorite)
    }
    
    enum CodingKeys: String, CodingKey {
        case image
        case emotion
        case probabilities
        case date
        case isFavorite
    }
    
    mutating func update(isFavorite: Bool) -> Self {
        self.isFavorite = isFavorite
        return self
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(date)
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
         return lhs.date == rhs.date
     }
}
