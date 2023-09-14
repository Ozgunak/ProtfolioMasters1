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
                    ScrollView(.horizontal) {
                        HStack{
                            ForEach(vm.coverProjects) { project in
                                //                            NavigationLink(destination: DetailView2()) {
                                VStack {
                                    AsyncImage(url: URL(string: project.image)!, content: { image in
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            
                                    }, placeholder: {
                                        ProgressView()
                                    })
                                        
                                    Text("\(project.projectName)")
                                    Text("\(project.details)")
                                }
//                                .frame(width: 100)
                                .padding(4)
                                
                                //                            }
                            }
                        }
                    }
                    .frame(height: 250)
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
