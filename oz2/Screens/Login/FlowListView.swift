//
//  FlowListView.swift
//  oz2
//
//  Created by özgün aksoy on 2023-08-09.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift

struct FlowListView: View {
    @FirestoreQuery(collectionPath: "flowItem", animation: .easeIn) var flowItems: [FlowModel]
    @FirestoreQuery(collectionPath: "projects", animation: .easeIn) var projects: [FlowItemModel]
    @Environment(\.dismiss) private var dismiss
    @State private var isNewListPresented: Bool = false
    @State private var isNewProjectPresented: Bool = false
    @Binding var showLoginView: Bool
    @StateObject private var viewModel = FlowListViewModel()
    @State private var titleText: String = "Welcome"

    
    var body: some View {
        NavigationStack {
            List {
//                ForEach(flowItems) { item in
//                    VStack(alignment: .leading) {
//                        NavigationLink(destination: {
//                            CreateProfileView(flow: item)
//                        }, label: {
//                            FlowHeaderView(name: item.name, title: item.title, country: "Ca", profileImage: item.profileImage)
//                        })
//
//                    }
//                }
                ForEach(projects) { item in
                    VStack(alignment: .leading) {
                        NavigationLink(destination: {
//                            CreateProfileView(flow: item)
                        }, label: {
                            ProjectFlowItemView(project: item)
                        })

                    }
                }

            }
            .listStyle(.plain)
            .navigationTitle(titleText)
            .task {
                do {
                    try await viewModel.loadCurrentUser()
                    if let id = viewModel.user?.userId {
                        titleText = "Welcome \(id)"
                    }
                } catch {
                    print("Error: cant load current user \(error.localizedDescription)")
                }
            }
            // MARK: Toolbar
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Log Out") {
                        do {
                            try viewModel.signout()
                            showLoginView = true
//                            dismiss()
                        } catch {
                            print("😡 Error: sign out \(error.localizedDescription)")
                        }
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu("Add") {
                        Button {
                            isNewProjectPresented.toggle()
                        } label: {
                            Image(systemName: "plus")
                            Text("Add New Project")
                        }
                        
                        Button {
                            isNewListPresented.toggle()
                        } label: {
                            Image(systemName: "plus")
                            Text("Add New Profile")
                        }
                    }
                    
                    
                }
            }
            // MARK: sheet
            .sheet(isPresented: $isNewListPresented) {
                NavigationStack {
                    CreateProfileView(flow: FlowModel())
                }
            }
            .sheet(isPresented: $isNewProjectPresented) {
                NavigationStack {
                    NewProjectView(project: ProjectModel())
                }
            }
        }
    }
}



struct FlowListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            FlowListView(showLoginView: .constant(false))
        }
    }
}

struct ProjectFlowItemView: View {
    @State var project: FlowItemModel
    var body: some View {
        VStack(alignment: .leading) {
            FlowHeaderView(name: project.name, title: project.title, country: "Ca", profileImage: project.progileImage)
            Text(project.projectName)
            let _ = print(project)
            CarouselDetailView(imageNames: project.imageNames)
            HStack {
                Image(systemName: "heart")
                Text("112 Likes")
                Spacer()
                Text("Last Active 5 mins ago").font(.caption)
            }
        }
    }
}
