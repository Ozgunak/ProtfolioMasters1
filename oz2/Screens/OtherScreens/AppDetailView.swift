//
//  AppDetailView.swift
//  oz2
//
//  Created by özgün aksoy on 2023-07-29.
//

import SwiftUI

struct AppDetailView: View {
    let project: ProjectModel
    var editActive:Bool = false

    @State private var nameText: String
    @State private var descriptionText: String
    @State private var detailText: String = "dsadsadsadsad"

    
    init(project: ProjectModel) {
        self.project = project
        _nameText = State(initialValue: project.name)
        _descriptionText = State(initialValue: project.description)
        _detailText =  State(initialValue: project.detail ?? "hi")
    }
    
    var body: some View {
        ZStack {
            Color(.darkGray)
                .ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack {
                    CarouselDetailView(imageNames: project.imageNames ?? ["phone"])
                        .frame(height: CarouselConstants.viewHeight)
                    
                    VStack {
                        Text(project.name).font(.title).foregroundColor(.white)
                        
                        Text(project.description).font(.subheadline).foregroundColor(.white).multilineTextAlignment(.leading)
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(20)
                    
                    VStack {
                        Text(project.detail ?? "My Project").padding().foregroundColor(.white)
                        
                        ForEach(project.tech, id: \.self) { tech in
                            HStack {
                                Image(systemName: "star").foregroundColor(.white)
                                Text(tech).foregroundColor(.white)
                            }.padding(.bottom, 2)
                        }
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

struct CarouselDetailView: View {
    let imageNames: [String]

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: CarouselConstants.spacing) {
                ForEach(imageNames.indices, id: \.self) { index in
                    CarouselImage(imageName: imageNames[index])
                }
            }
            .padding(.horizontal, UIScreen.main.bounds.width / 3 - CarouselConstants.spacing * 2)
        }
    }
}

struct CarouselImage: View {
    let imageName: String
    
    var body: some View {
        GeometryReader { geometry in
            NavigationLink {
                ZStack {
                    Color(.black)
                    Image(imageName).resizable().scaledToFit()
                }
            } label: {
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: UIScreen.main.bounds.width / 3)
                    .clipped()
                    .shadow(radius: 5)
                .scaleEffect(self.scaleEffect(for: geometry))
            }
        }
        .frame(width: UIScreen.main.bounds.width / 3, height: CarouselConstants.imageHeight)
    }
    
    private func scaleEffect(for geometry: GeometryProxy) -> CGFloat {
        let absoluteCenterX = geometry.frame(in: .global).midX
        let distanceFromCenter = abs(UIScreen.main.bounds.width / 2 - absoluteCenterX)
        
        let relativeDistance = distanceFromCenter / (UIScreen.main.bounds.width / 2)
        
        let scaleDifference = CarouselConstants.centerImageScale - CarouselConstants.sideImageScale
        let scale = CarouselConstants.centerImageScale - scaleDifference * relativeDistance
        
        return scale
    }
}



enum CarouselConstants {
    static let spacing: CGFloat = 8
    static let sideImageScale: CGFloat = 0.7
    static let centerImageScale: CGFloat = 1.1
    static let viewHeight: CGFloat = 320
    static let imageHeight: CGFloat = 300
    
}

struct AppDetailView_Previews: PreviewProvider {
    static var previews: some View {
        AppDetailView(project: ProjectModel(name: "New Project", description: "Brand New Project That I Created", tech: ["tech 1", "tech 2", "tech 3", "tech 4", ], detail: "What I learned in this project"))
    }
}
