//
//  AnalysisManager.swift
//  Just-Puppy
//
//  Created by Doyoung Song on 10/29/23.
//

import Foundation
import OrderedCollections
import SwiftUI

final class AnalysisManager: ObservableObject {
    
    @Published private(set) var analyses: OrderedSet<Analysis> = []
    static let shared = AnalysisManager()
    
    private init() {}
}

// MARK: - Methods
extension AnalysisManager {
    
    func saveAnalysis(_ analysis: Analysis) {
        if analyses.contains(analysis), let index = analyses.firstIndex(of: analysis) {
            analyses.remove(analysis)
            analyses.insert(analysis, at: index)
        } else {
            analyses.insert(analysis, at: 0)
        }
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            self?.saveFile(analysis)
        }
    }
    
    func deleteAnalysis(_ analysis: Analysis) {
        analyses.remove(analysis)
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            self?.deleteFile(analysis)
        }
    }
    
    func loadFiles() {
        guard let fileURLs = try? FileManager.default.contentsOfDirectory(at: directoryPath,
                                                                          includingPropertiesForKeys: [.contentModificationDateKey],
                                                                          options: .skipsHiddenFiles) else { return }
        let sortedURLs = fileURLs.map { url in
            ( url, (try? url.resourceValues(forKeys: [.contentModificationDateKey]) )?.contentModificationDate ?? Date.distantPast)
        }
            .sorted(by: { $0.1 > $1.1 })
            .map { $0.0 }
        
        var analyses: OrderedSet<Analysis> = []
        
        do {
            for url in sortedURLs {
                let data = try Data(contentsOf: url)
                let analysis = try JSONDecoder().decode(Analysis.self, from: data)
                analyses.append(analysis)
            }
            self.analyses = analyses
        } catch {
            print(error)
        }
    }
    
    func deleteAllAnalyses() {
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            guard let self else { return }
            for analysis in analyses {
                deleteFile(analysis)
            }
            analyses.removeAll()
        }
    }
}

// MARK: - Private Functions
extension AnalysisManager {
    
    private func saveFile(_ analysis: Analysis) {
        do {
            try FileManager.default.createDirectory(at: directoryPath, withIntermediateDirectories: true, attributes: nil)
            let filePath = directoryPath.appendingPathComponent(analysis.date.yyyyMMddHHmmssNoSeperator)
            let data = try JSONEncoder().encode(analysis)
            try data.write(to: filePath)
        } catch {
            print(error, directoryPath.appendingPathComponent(analysis.date.yyyyMMddHHmmssNoSeperator))
        }
    }
    
    private func deleteFile(_ analysis: Analysis) {
        do {
            let filePath = directoryPath.appendingPathComponent(analysis.date.yyyyMMddHHmmssNoSeperator)
            try FileManager.default.removeItem(at: filePath)
        } catch {
            print(error, directoryPath.appendingPathComponent(analysis.date.yyyyMMddHHmmssNoSeperator))
        }
    }
}

// MARK: - Computed Properties
extension AnalysisManager {
    
    private var directoryPath: URL {
        let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return documentPath.appendingPathComponent("emotion_analyses")
    }
}
