//
//  oz2App.swift
//  oz2
//
//  Created by özgün aksoy on 2023-07-25.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

@main
struct oz2App: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @StateObject var flowVM = FlowViewModel()
    @StateObject var profileVM = MyProfileViewModel()
    
    var body: some Scene {
        WindowGroup {
            LoginView()
                .environmentObject(flowVM)
                .environmentObject(profileVM)
        }
    }
}
