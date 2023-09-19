//
//  ScrollableAppView.swift
//  oz2
//
//  Created by özgün aksoy on 2023-07-29.
//

import SwiftUI

@MainActor
class ScrollableAppViewModel: ObservableObject {
    
    @Published var coverProject: CoverProjectModel? = nil
    @Published var coverProjects: [CoverProjectModel] = []
    
    func getProjects() async throws {
        let user = try AuthenticationManager.shared.getAuthUser()
        coverProjects = try await FirestoreManager.shared.getUserCoverProject(userID: user.uid)
    }
    
}

struct ScrollableAppView: View {
    
    @StateObject var vm = ScrollableAppViewModel()
    @State private var isLoading: Bool = false
    
    var body: some View {
        VStack {
            if isLoading {
                ProgressView()
            } else {
                
                VStack {
                    Text("Example Apps")
                        .font(.title2)
                        .padding(.bottom, 4)
                    if #available(iOS 17, *) {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(vm.coverProjects) { project in
                                    itemView(item: project)
                                }
                            }
                            .scrollTargetLayout()
                        }
                        .scrollTargetBehavior(.viewAligned)
                        .contentMargins(-10, for: .scrollContent)
                        
                    } else {
                        ProgressView()
                        Text("Work In progress")
                        //                        ScrollView(.horizontal) {
                        //                            HStack{
                        //                                ForEach(vm.coverProjects) { project in
                        //                                    //                            NavigationLink(destination: DetailView2()) {
                        //                                    VStack {
                        //                                        AsyncImage(url: URL(string: project.image)!, content: { image in
                        //                                            image
                        //                                                .resizable()
                        //                                                .aspectRatio(contentMode: .fill)
                        //
                        //                                        }, placeholder: {
                        //                                            ProgressView()
                        //                                        })
                        //
                        //                                        Text("\(project.projectName)")
                        //                                        Text("\(project.details)")
                        //                                    }
                        //                                    //                                .frame(width: 100)
                        //                                    .padding(4)
                        //
                        //                                    //                            }
                        //                                }
                        //                            }
                        //                        }
                            .frame(height: 250)
                    }
                }
                .padding(.vertical)
                .background(.thinMaterial)
                .cornerRadius(20)
                .shadow(radius: 2)
            }
        }
        .onAppear {
            isLoading = true
            Task {
                try await vm.getProjects()
                isLoading = false
            }
        }
        
    }
}

extension ScrollableAppView {
    
    @available(iOS 17.0, *)
    func itemView(item: CoverProjectModel) -> some View {
        ZStack(alignment: .bottom) {
            AsyncImage(url: URL(string: item.image)!, content: { image in
                image
                    .resizable()
                    .scaledToFill()
//                    .frame(width: 400,height: 400)
                    .containerRelativeFrame(.horizontal)
                    .clipShape(.rect(cornerSize: CGSize(width: 20, height: 20)))
                
            }, placeholder: {
                ProgressView()
            })
            
            VStack(spacing: 0) {
                Rectangle()
                    .fill(.white)
                    .frame(height: 3)
                
                HStack(alignment: .center) {
                    VStack(alignment: .center) {
                        Text(item.projectName)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity, alignment: .center)
                        
                        Text(item.details)
                            .font(.footnote)
                    }
                    .padding(.horizontal)
                    
//                    Spacer()
                    
                    //                    TODO: add like here
                    //                    Button {
                    //                        dataModel.add(to: item)
                    //                    } label: {
                    //                        Label(dataModel.count(for: item), systemImage: "hand.thumbsup")
                    //                    }
                    //                    .buttonStyle(.plain)
                }
                .font(.title3.bold())
                .padding(10)
                .padding(.horizontal, 10)
                .background(.green.gradient)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 25))
        .shadow(color: .black.opacity(0.2), radius: 2)
        .padding(4)
        .containerRelativeFrame(.horizontal)
    }
}


extension ScrollableAppView {
    
    @available(iOS 17.0, *)
    var pagingScrollView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(vm.coverProjects) { project in
                    VStack {
                        AsyncImage(url: URL(string: project.image)!, content: { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 250, height: 250)
                                .padding()
                            
                        }, placeholder: {
                            ProgressView()
                        })
                        Text("\(project.projectName)")
                        Text("\(project.details)")
                    }
                    .frame(height: 300)
                    .containerRelativeFrame(.horizontal)

                }
            }
            .scrollTargetLayout()
        }
        .scrollTargetBehavior(.viewAligned)
        .contentMargins(20, for: .scrollContent)
        
    }
    
}


import FirebaseFirestoreSwift
import Firebase

struct CoverProjectModel: Identifiable, Codable {
    @DocumentID var id: String?
    var projectName: String
    var image: String
    var keywords: String
    var isStillWorking: Bool
    var details: String
    var publishTime: Date?
    
    var dictionary: [String: Any] {
        return ["projectName": projectName, "image": image, "keywords": keywords, "isStillWorking": isStillWorking, "details": details, "publishTime": Timestamp(date: Date())]
    }
}

struct ScrollableAppView_Previews: PreviewProvider {
    static var previews: some View {
        ScrollableAppView()
    }
}
