//
//  TaskManager.swift
//  Habbeats
//
//  Created by Konstantin Romashin on 10/9/2567 BE.
//

import Foundation

class TaskManager: ObservableObject {
    @Published var tasks: [Task] = [] {
        didSet {
            saveTasks()
        }
    }
    
    init() {
        loadTasks()
        resetTasksIfNewDay()
    }
    
    func saveTasks() {
        if let encodedTasks = try? JSONEncoder().encode(tasks) {
            UserDefaults.standard.set(encodedTasks, forKey: "tasks")
        }
    }
    
    func loadTasks() {
        if let savedTasks = UserDefaults.standard.data(forKey: "tasks"),
           let decodedTasks = try? JSONDecoder().decode([Task].self, from: savedTasks) {
            self.tasks = decodedTasks
        } else {
            self.tasks = [
                Task(title: TaskTitles.sleep,
                     description: TaskDescriptions.sleep,
                     streak: 0,
                     progress: 0,
                     maxValue: 7),
                
                Task(title: TaskTitles.walk,
                     description: TaskDescriptions.walk,
                     streak: 0,
                     progress: 0,
                     maxValue: 10000),
                
                Task(title: TaskTitles.socialMedia,
                     description: TaskDescriptions.socialMedia,
                     streak: 0,
                     progress: 0,
                     maxValue: 1),
                
                Task(title: TaskTitles.meals,
                     description: TaskDescriptions.meals,
                     streak: 0,
                     progress: 0,
                     maxValue: 3),
                
                Task(title: TaskTitles.water,
                     description: TaskDescriptions.water,
                     streak: 0,
                     progress: 0,
                     maxValue: 8),
                
                Task(title: TaskTitles.read,
                     description: TaskDescriptions.read,
                     streak: 0,
                     progress: 0,
                     maxValue: 30),
            ]
        }
    }
    
    func resetTasksIfNewDay() {
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd"
        let nowDayString = dateFormatter.string(from: now)
        
        for index in tasks.indices {
            var task = tasks[index]
            let timeDifference = now.timeIntervalSince(task.progressUpdated)
            
            if timeDifference >= 24 * 60 * 60 {
                task.progress = 0
                task.streak = 0
                task.progressUpdated = Date()
                task.streakUpdated = Date()
            }
            
            if now < task.progressUpdated || now < task.streakUpdated {
                task.progress = 0
                task.streak = 0
                task.progressUpdated = Date()
                task.streakUpdated = Date()
            }
            
            if let nowDay = Int(nowDayString), let lastUpdatedDay = Int(dateFormatter.string(from: task.progressUpdated)), nowDay - lastUpdatedDay <= -1 || nowDay - lastUpdatedDay >= 1 {
                task.progress = 0
                task.progressUpdated = Date()
            }
            
//            if let nowDay = Int(nowDayString), let lastUpdatedDay = Int(dateFormatter.string(from: task.progressUpdated)), nowDay - lastUpdatedDay >= 1 {
//                task.progress = 0
//                task.progressUpdated = Date()
//            }
            
            if let nowDay = Int(nowDayString), let streakDay = Int(dateFormatter.string(from: task.streakUpdated)), nowDay - streakDay <= -1 || nowDay - streakDay >= 2 {
                task.streak = 0
                task.streakUpdated = Date()
            }
            
//            if let nowDay = Int(nowDayString), let streakDay = Int(dateFormatter.string(from: task.streakUpdated)), nowDay - streakDay >= 2 {
//                task.streak = 0
//                task.streakUpdated = Date()
//            }
            
            tasks[index] = task
        }
        
        saveTasks()
    }
}
