//
//  Task.swift
//  Habbeats
//
//  Created by Konstantin Romashin on 9/9/2567 BE.
//

import Foundation

struct Task: Identifiable, Codable {
    let id: UUID
    let title: String
    let description: String
    var streak: Int
    var progress: Double
    let maxValue: Double
    var progressUpdated: Date
    var streakUpdated: Date
    
    init(id: UUID = UUID(), title: String, description: String, streak: Int, progress: Double, maxValue: Double, progressUpdated: Date = Date(), streakUpdated: Date = Date()) {
        self.id = id
        self.title = title
        self.description = description
        self.streak = streak
        self.progress = progress
        self.maxValue = maxValue
        self.progressUpdated = progressUpdated
        self.streakUpdated = streakUpdated
    }
}
