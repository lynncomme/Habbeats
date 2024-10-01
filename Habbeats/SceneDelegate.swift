//
//  SceneDelegate.swift
//  Habbeats
//
//  Created by Konstantin Romashin on 8/9/2567 BE.
//

import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    let taskManager = TaskManager()
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            
            let splashScreen = SplashScreen()
                .environmentObject(taskManager)
            
            window.rootViewController = UIHostingController(rootView: splashScreen)
            
            window.backgroundColor = UIColor(Color("Background"))
            
            self.window = window
            window.makeKeyAndVisible()
        }
    }
}
