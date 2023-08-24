//
//  TabBarView.swift
//  oz2
//
//  Created by özgün aksoy on 2023-08-22.
//

import SwiftUI

struct TabBarView: View {
    @Binding var showLoginView: Bool
    var body: some View {
        TabView {
            NavigationStack {
                FlowListView(showLoginView: $showLoginView)
            }
            .tabItem {
                Image(systemName: "house")
                Text("Home")
            }
            NavigationStack {
                ProfileView()
            }
            .tabItem {
                Image(systemName: "person")
                Text("Profile")
            }
            NavigationStack {
                SettingsView()
            }
            .tabItem {
                Image(systemName: "gear")
                Text("Settings")
            }
        }
        
    }
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView(showLoginView: .constant(false))
    }
}
