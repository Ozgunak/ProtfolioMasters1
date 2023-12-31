//
//  AppDetailView.swift
//  oz2
//
//  Created by özgün aksoy on 2023-07-29.
//

import SwiftUI

struct AppDetailView: View {
    var project: ProjectModel
    var editActive:Bool = false

    @State private var nameText: String
    @State private var descriptionText: String
    @State private var detailText: String = "dsadsadsadsad"

    
    init(project: ProjectModel) {
        self.project = project
        _nameText = State(initialValue: project.name)
        _descriptionText = State(initialValue: project.description)
        _detailText =  State(initialValue: project.detail )
    }
    
    var body: some View {
        ZStack {
            Color(.darkGray)
                .ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack {
//                    CarouselDetailView(imageNames: project.imageNames ?? ["phone"])
//                        .frame(height: CarouselConstants.viewHeight)
                    
                    VStack {
                        Text(project.name).font(.title).foregroundColor(.white)
                        
                        Text(project.description).font(.subheadline).foregroundColor(.white).multilineTextAlignment(.leading)
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(20)
                    
                    VStack {
                        Text(project.detail ?? "My Project").padding().foregroundColor(.white)
                        
//                        ForEach(project.tech, id: \.self) { tech in
//                            HStack {
//                                Image(systemName: "star").foregroundColor(.white)
//                                Text(tech).foregroundColor(.white)
//                            }.padding(.bottom, 2)
//                        }
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(20)
                    
                    Text("Github Link").foregroundColor(.white)
                    Text("AppStore if possible Link").foregroundColor(.white)
                    
                    Spacer()
                }
            }
        }
    }

}

//struct AppDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        AppDetailView(project: ProjectModel(name: "New Project", description: "Brand New Project That I Created", tech: ["tech 1", "tech 2", "tech 3", "tech 4", ], detail: "What I learned in this project"))
//    }
//}
