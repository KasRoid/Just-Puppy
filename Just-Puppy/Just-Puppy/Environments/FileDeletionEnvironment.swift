//
//  FileDeletionEnvironment.swift
//  Just-Puppy
//
//  Created by Doyoung Song on 10/22/23.
//

import ComposableArchitecture
import Foundation

struct FileDeletionEnvironment {
    var analysis: (Analysis) -> Result<Void, Error>
}

extension FileDeletionEnvironment: DependencyKey {
    
    static var liveValue = FileDeletionEnvironment { analysis in
        let fileManager = FileManager.default
        let documentPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let directoryPath = documentPath.appendingPathComponent("emotion_analyses")
        
        do {
            let filePath = directoryPath.appendingPathComponent(analysis.date.yyyyMMddHHmmssNoSeperator)
            try fileManager.removeItem(at: filePath)
            return .success(())
        } catch {
            return .failure(error)
        }
    }
}

extension DependencyValues {
    
    var fileDeletionEnvironment: FileDeletionEnvironment {
        get { self[FileDeletionEnvironment.self] }
        set { self[FileDeletionEnvironment.self] = newValue }
    }
}
