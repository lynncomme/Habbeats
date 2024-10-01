//
//  TaskCard.swift
//  Habbeats
//
//  Created by Konstantin Romashin on 8/9/2567 BE.
//

import SwiftUI
import UIKit
import HealthKit

struct TaskCard: View {
    @Binding var task: Task
    @EnvironmentObject var taskManager: TaskManager
    
    @State private var isExpanded: Bool = false
    
    @State private var stepCount: Double = 0
    private let healthStore = HKHealthStore()
    private let stepCountType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
    
    private let feedbackGenerator = UIImpactFeedbackGenerator(style: .soft)
    private let feedbackGeneratorTap = UISelectionFeedbackGenerator()
    
    private var progressFraction: Double {
        task.title == TaskTitles.walk ? min(stepCount / task.maxValue, 1.0) : task.maxValue > 0 ? min(task.progress / task.maxValue, 1.0) : 0.0
    }
    
    private var streakText: String {
        let dayString = task.streak == 1 ? NSLocalizedString("Day", comment: "") : NSLocalizedString("Days", comment: "")
        return String(format: NSLocalizedString("StreakText", comment: ""), task.streak, dayString)
    }
    
    private var endTaskText: String {
        task.title == TaskTitles.walk ? NSLocalizedString("TaskWillCompleteAutomatically", comment: "") : NSLocalizedString("EndTask", comment: "")
    }
    
    private func checkAndResetTasks() {
        let now = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd"
        if let nowDay = Int(formatter.string(from: now)), let progressUpdatedDay = Int(formatter.string(from: task.progressUpdated)), let streakUpdatedDay = Int(formatter.string(from: task.streakUpdated)), nowDay != progressUpdatedDay || nowDay != streakUpdatedDay {
            taskManager.resetTasksIfNewDay()
        }
    }
    
    private func incrementProgress() {
        checkAndResetTasks()
        if task.progress + 1 >= task.maxValue {
            task.progress = task.maxValue
            task.streak += 1
            task.progressUpdated = Date()
            task.streakUpdated = Date()
            feedbackGenerator.impactOccurred()
        } else {
            task.progress += 1
            task.progressUpdated = Date()
            feedbackGeneratorTap.selectionChanged()
        }
    }
    
    private func cardContent() -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 16) {
                Text(task.title)
                    .font(.custom("PlayfairDisplay-Regular", size: 14))
                    .foregroundColor(Color("TitleTextColor"))
                
                ProgressView(value: progressFraction, total: 1.0)
                    .progressViewStyle(LinearProgressViewStyle())
                    .accentColor(Color("TitleTextColor"))
                    .padding(.horizontal, 8)
                
                HStack {
                    Text(task.progress >= task.maxValue ? "Goal Ended" : task.title == TaskTitles.walk ? "Goal progress: \(Int(stepCount))/\(Int(task.maxValue))" : "Goal progress: \(Int(task.progress))/\(Int(task.maxValue))")
                        .font(.custom("SourceSansPro-Regular", size: 14))
                        .foregroundColor(Color("ProgressTextColor"))
                    
                    Spacer()
                    
                    Text(streakText)
                        .font(.custom("SourceSansPro-Regular", size: 14))
                        .foregroundColor(Color("StreakTextColor"))
                }
            }
            .padding(.trailing, 16)
            
            Image(systemName: "chevron.right")
                .rotationEffect(.degrees(isExpanded ? 90 : 0))
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(Color("ArrowColor"))
                .padding(.trailing, 16)
        }
        .contentShape(Rectangle())
        .padding(.vertical, 4)
        .padding(.leading, 8)
    }
    
    private func expandedContent() -> some View {
        VStack(alignment: .center, spacing: 16) {
            Divider().frame(height: 1).background(Color("Text")).opacity(0.2)
                .padding(.horizontal, 24)
            
            Text(task.description)
                .font(.custom("SourceSansPro-Regular", size: 14))
                .foregroundColor(Color("DescriptionTextColor"))
                .multilineTextAlignment(.center)
                .padding(.all, 8)
            
            Divider().frame(height: 1).background(Color("Text")).opacity(0.2)
                .padding(.horizontal, 24)
            
            if task.title != TaskTitles.walk {
                taskActionButton(title: "Increase Progress by 1") {
                    checkAndResetTasks()
                    incrementProgress()
                }
            }
            
            taskActionButton(title: endTaskText) {
                checkAndResetTasks()
                if task.title != TaskTitles.walk {
                    task.progress = task.maxValue
                    task.streak += 1
                    task.progressUpdated = Date()
                    task.streakUpdated = Date()
                    feedbackGenerator.impactOccurred()
                }
            }
        }
        .padding(.vertical, 7.5)
    }
    
    private func taskActionButton(title: String, action: @escaping () -> Void) -> some View {
        VStack {
            Text(title)
                .font(.custom("Merriweather-Regular", size: 13))
                .foregroundColor(Color("Text"))
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color("Background"))
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color("BorderColor"), lineWidth: 1))
        }
        .contentShape(Rectangle())
        .onTapGesture { action() }
    }
    
    private func requestHealthKitAuthorization() {
        let typesToRead: Set<HKObjectType> = [stepCountType]
        healthStore.requestAuthorization(toShare: [], read: typesToRead) { (success, error) in
            if success {
                self.fetchStepCount()
            }
        }
    }
    
    private func fetchStepCount() {
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now)
        let query = HKStatisticsQuery(quantityType: stepCountType, quantitySamplePredicate: predicate, options: .cumulativeSum) { (query, result, error) in
            guard let result = result, let sum = result.sumQuantity() else {
                return
            }
            
            DispatchQueue.main.async {
                let stepCount = sum.doubleValue(for: HKUnit.count())
                self.stepCount = stepCount
                
                if self.task.title == TaskTitles.walk {
                    if stepCount >= self.task.maxValue {
                        if self.task.progress != self.task.maxValue {
                            self.task.progress = self.task.maxValue
                            self.task.streak += 1
                            self.task.progressUpdated = Date()
                            self.task.streakUpdated = Date()
                        }
                    }
                }
            }
        }
        
        healthStore.execute(query)
    }
    
    var body: some View {
        VStack {
            cardContent()
                .onTapGesture {
                    if task.progress < task.maxValue {
                        isExpanded.toggle()
                        feedbackGenerator.impactOccurred()
                    }
                }
            
            if isExpanded {
                expandedContent()
            }
        }
        .padding()
        .background(Color.clear)
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color("BorderColor"), lineWidth: 1))
        .onAppear {
            requestHealthKitAuthorization()
        }
    }
}
