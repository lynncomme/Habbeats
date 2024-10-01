//
//  Constants.swift
//  Habbeats
//
//  Created by Konstantin Romashin on 8/9/2567 BE.
//

import Foundation

// MARK: - Main Screen Text
struct MainScreenText {
    static let description = NSLocalizedString("MainScreenDescription", comment: "Main screen introductory text")
    static let incompleteTasks = NSLocalizedString("IncompleteTasks", comment: "Title for incomplete tasks section")
    static let completedTasks = NSLocalizedString("CompletedTasks", comment: "Title for completed tasks section")
}

// MARK: - Task Titles
struct TaskTitles {
    static let sleep = NSLocalizedString("SleepTitle", comment: "Title for sleep task")
    static let walk = NSLocalizedString("WalkTitle", comment: "Title for walking task")
    static let socialMedia = NSLocalizedString("SocialMediaTitle", comment: "Title for social media task")
    static let meals = NSLocalizedString("MealsTitle", comment: "Title for meals task")
    static let water = NSLocalizedString("WaterTitle", comment: "Title for water task")
    static let read = NSLocalizedString("ReadTitle", comment: "Title for reading task")
}

// MARK: - Task Descriptions
struct TaskDescriptions {
    static let sleep = NSLocalizedString("SleepDescription", comment: "Description for sleep task")
    static let walk = NSLocalizedString("WalkDescription", comment: "Description for walking task")
    static let socialMedia = NSLocalizedString("SocialMediaDescription", comment: "Description for social media task")
    static let meals = NSLocalizedString("MealsDescription", comment: "Description for meals task")
    static let water = NSLocalizedString("WaterDescription", comment: "Description for water task")
    static let read = NSLocalizedString("ReadDescription", comment: "Description for reading task")
}

// MARK: - Task Progress Labels
struct TaskProgressLabels {
    static func goalProgress(current: Int, total: Int) -> String {
        return String(format: NSLocalizedString("GoalProgress", comment: "Progress of the goal"), current, total)
    }
}

// MARK: - Task Card
struct TaskCardText {
    static func streak(days: Int) -> String {
        return String(format: NSLocalizedString("StreakText", comment: "Streak text"), days)
    }
}
