//
//  ContentView.swift
//  oz2
//
//  Created by özgün aksoy on 2023-07-25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.darkGray)
                    .ignoresSafeArea()

                TabView {
                    FlowScreen()
                        .background(.gray)
                        .tabItem {
                            Image(systemName: "house")
                            Text("Home")
                        }.environmentObject(FlowViewModel())
                    
                    ExploreView()
                        .background(.gray)
                        .tabItem {
                            Image(systemName: "gyroscope")
                            Text("Explore")
                        }
                    MyProfileScreen()
                        .background(.gray)
                        .tabItem {
                            Image(systemName: "person.crop.circle")
                            Text("Profile")
                        }
                        .environmentObject(MyProfileViewModel())
                    
                    NewProjectView(project: ProjectModel())
                    // TODO: replace
                        .background(.gray)
                        .tabItem {
                            Image(systemName: "briefcase")
                            Text("Projects")
                        }
                }                    
//                .navigationTitle(Text("Portfolio Masters"))
//                .navigationBarTitleDisplayMode(.automatic)
            }
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

