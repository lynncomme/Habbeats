//
//  ContentView.swift
//  Habbeats
//
//  Created by Konstantin Romashin on 8/9/2567 BE.
//

import Foundation
import SwiftUI

struct ContentView: View {
    @EnvironmentObject var taskManager: TaskManager
    
    private var incompleteTasks: [Task] {
        taskManager.tasks
            .filter { $0.progress < $0.maxValue }
            .sorted { $0.streak > $1.streak }
    }
    
    private var completedTasks: [Task] {
        taskManager.tasks
            .filter { $0.progress >= $0.maxValue }
            .sorted { $0.streakUpdated > $1.streakUpdated }
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                Text(MainScreenText.description)
                    .font(.custom("Merriweather-Regular", size: 14))
                    .foregroundColor(Color("Text"))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 8)
                
                if !incompleteTasks.isEmpty {
                    VStack(alignment: .trailing, spacing: 16) {
                        Text(MainScreenText.incompleteTasks)
                            .font(.custom("PlayfairDisplay-Regular", size: 14))
                            .foregroundColor(Color("TitleTextColor"))
                            .padding(.trailing, 24)
                        
                        ForEach(incompleteTasks) { task in
                            TaskCard(task: $taskManager.tasks[taskManager.tasks.firstIndex(where: { $0.id == task.id })!])
                        }
                    }
                }
                
                if !completedTasks.isEmpty {
                    VStack(alignment: .trailing, spacing: 16) {
                        Text(MainScreenText.completedTasks)
                            .font(.custom("PlayfairDisplay-Regular", size: 14))
                            .foregroundColor(Color("TitleTextColor"))
                            .padding(.trailing, 24)
                        
                        ForEach(completedTasks) { task in
                            TaskCard(task: $taskManager.tasks[taskManager.tasks.firstIndex(where: { $0.id == task.id })!])
                        }
                    }
                }
                
                //                VStack(alignment: .trailing, spacing: 16) {
                //                    Text("Explore Custom Tasks")
                //                        .font(.custom("PlayfairDisplay-Regular", size: 14))
                //                        .foregroundColor(Color("TitleTextColor"))
                //                        .padding(.trailing, 24)
                //
                //                    ForEach(taskManager.customTasks, id: \.title) { task in
                //                        LockedTaskCard(title: task.title, description: task.description)
                //                    }
                //                }
            }
            .padding()
        }
        .background(Color("Background").ignoresSafeArea())
        .scrollIndicators(.hidden)
    }
}
