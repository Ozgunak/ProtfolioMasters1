//
//  ProfileScreen.swift
//  oz2
//
//  Created by özgün aksoy on 2023-07-29.
//

import SwiftUI

struct ProfileScreen: View {
    @State var user: UserProfileModel = UserProfileModel(name: "Oz Aksoy", title: "iOS Developer", country: "CA", projects: projects)
//    private var selfUser: Bool = false
    // TODO: Replace with self profile
    var body: some View {
        ZStack {
            Color(.darkGray).ignoresSafeArea()
            
            VStack {
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .center) {
                        HStack {
                            Text(user.name)
                                .padding()
                                .font(.headline)
                                .background(.thinMaterial)
                                .clipShape(Capsule())
                                .cornerRadius(20)
                                .shadow(radius: 10)
                            
                            Image("profileIcon")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 60, height: 60)
                                .clipShape(Circle())
                        }
                        Text(" Let's bring ideas to life! ")
                            .font(.caption)
                            .foregroundColor(.white)
                            .padding()
                            .cornerRadius(20)
                            .shadow(radius: 2)
                    }
                    VStack(alignment: .leading) {
                        CarouselView(projects1: $user.projects)
                        InfoView().padding(.horizontal)
                    }
                }
            }
        }.navigationTitle(user.name).foregroundColor(.white).tint(.white)
    }
    
    
    
}

struct ProfileScreen_Previews: PreviewProvider {
    static var previews: some View {
        ProfileScreen()
    }
}






struct CarouselView: View {
    @Binding var projects1: [ProjectModel]?
    
    private func getScale(proxy: GeometryProxy) -> CGFloat {
        var scale: CGFloat = 1
        let x = proxy.frame(in: .global).minX
        
        let diff = abs(x)
        if diff < 150 {
            scale = 1 + abs((150 - diff) / 700)
        }
        return scale
    }
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 50) {
                ForEach(projects, id: \.self) { item in
                    GeometryReader { proxy in
                        NavigationLink(destination: AppDetailView(project: item)) {
                            VStack(alignment: .center) {
                                let scale = getScale(proxy: proxy)
                                
                                Image(item.imageNames?.first ?? "plusPhone")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 150)
                                    .clipped()
                                    .cornerRadius(5)
                                    .shadow(color: .white, radius: 5)
                                    .scaleEffect(CGSize(width: scale, height: scale))
                                
                                
                                Text(item.name).padding(8).foregroundColor(.white).multilineTextAlignment(.center).background(.thinMaterial).clipShape(Capsule())
                            }
                        }
                        
                        //
                    }
                    .frame(width: 125, height: 400)
                }
                
            }
            .padding(32)
        }
    }
}


var profiles: [UserProfileModel] = [UserProfileModel(name: "Oz Aksoy", title: "iOS Developer", country: "CA", projects: projects), UserProfileModel(name: "Zey Aksoy", title: "iOS Developer", country: "CA", projects: projects)]


var projects:[ProjectModel] = [
    ProjectModel(name: "AR&EZ", description: "I've designed and developed an application called \"AR&EZ\" to increase the usability of local stores with the mobile application.", tech: ["UIKit", "Firebase", "OneSignal", "CoreData"], developmentTime: "1 month", imageNames: ["arez1","arez2","arez3","arez4","arez5"]),
    ProjectModel(name: "To Do App", description:
                """
            Todo App is a final project for Mobven Bootcamp. \n This project is created with VIP clean architecture pattern. \nCreate, Read, Update and Delete (CRUD) with CoreData \nLocal notifications can be set \nTodos should be created with title. Descriptions and notifications are optional. \nNotification gets deleted if todo deleted or marked as done.
            As default todos sorted by creation time. Sorting by last or first modification date can be done with sort button. \nUser can search by title
            """, tech: ["UIKit", "Github", "CoreData"], developmentTime: "2 weeks", imageNames: ["todo1", "todo2", "todo3", "todo4", "todo5",]),
    ProjectModel(name: "Grocery", description: """
Grocery Shop app lets you buy items with a few taps.
You can add item to your cart.
You can check categories and add different items to cart togerher.
Increasing, decreasing and deleting item from cart is possible.
With this lovely app every order you make is a success.
Since this is learning project, a few details created randomly like prices and images.
"""
            , tech: ["UIKit", "Firebase", "Github", "CoreData"], developmentTime: "4 days", imageNames: ["grocery1", "grocery2", "grocery3", "grocery4", "grocery5"]),
    ProjectModel(name: "Add Project", description: "", tech: [])]

