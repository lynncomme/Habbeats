//
//  HabbeatsApp.swift
//  Habbeats
//
//  Created by Konstantin Romashin on 8/9/2567 BE.
//

import SwiftUI

@main
struct HabbeatsApp: App {
    @StateObject var taskManager = TaskManager()
    
    init() {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .clear
        appearance.shadowColor = .clear
        appearance.titleTextAttributes = [.foregroundColor: UIColor.clear]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.clear]
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
    
    var body: some Scene {
        WindowGroup {
            SplashScreen()
                .environmentObject(taskManager)
        }
    }
}
