//
//  oz2App.swift
//  oz2
//
//  Created by özgün aksoy on 2023-07-25.
//

import SwiftUI

@main
struct oz2App: App {
    @StateObject var flowVM = FlowViewModel()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(flowVM)
        }
    }
}
