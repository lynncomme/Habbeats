//
//  SplashScreen.swift
//  Habbeats
//
//  Created by Konstantin Romashin on 8/9/2567 BE.
//

import SwiftUI

struct SplashScreen: View {
    @State private var logoOpacity: Double = 0.0
    @State private var isActive: Bool = false
    @EnvironmentObject var taskManager: TaskManager

    var body: some View {
        ZStack {
            if isActive {
                ContentView()
                    .environmentObject(taskManager)
            } else {
                Color("Background")
                    .edgesIgnoringSafeArea(.all)
                
                Image("Habbeats")
                    .resizable()
                    .frame(width: 300, height: 300)
                    .opacity(logoOpacity)
                    .onAppear {
                        taskManager.resetTasksIfNewDay()
                        
                        withAnimation(.easeIn(duration: 0.5)) {
                            logoOpacity = 1.0
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            withAnimation(.easeOut(duration: 0.5)) {
                                logoOpacity = 0.0
                            }
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation {
                                isActive = true
                            }
                        }
                    }
            }
        }
    }
}

struct SplashScreen_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreen()
            .environmentObject(TaskManager())
    }
}
