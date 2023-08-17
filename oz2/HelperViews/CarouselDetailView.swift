//
//  CarouselImage.swift
//  oz2
//
//  Created by özgün aksoy on 2023-08-08.
//

import SwiftUI

struct CarouselDetailView: View {
    let imageNames: [String]
    var imageHeight: CGFloat = 360
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: CarouselConstants.spacing) {
                ForEach(imageNames.indices, id: \.self) { index in
                    CarouselImage(imageName: imageNames[index], imageHeight: imageHeight)
                }
            }
            .padding(.horizontal, UIScreen.main.bounds.width / 5 - CarouselConstants.spacing * 2)
        }
    }
}

struct CarouselImage: View {
    let imageName: String
    var imageHeight: CGFloat
    var body: some View {
        GeometryReader { geometry in
            NavigationLink {
                ZStack {
                    Color(.black)
                    AsyncImage(url: URL(string: imageName)) { image in
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: UIScreen.main.bounds.width / 2)
                            .shadow(radius: 5)
                    } placeholder: {
                        Image("phone")
                            .resizable()
                            .scaledToFit()
                            .frame(width: UIScreen.main.bounds.width / 2)
                            .clipped()
                            .shadow(radius: 5)
                            .scaleEffect(self.scaleEffect(for: geometry))
                    }
                }
            } label: {
                VStack {
                    AsyncImage(url: URL(string: imageName)) { image in
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: UIScreen.main.bounds.width / 2)
                            .shadow(radius: 5)
                            .clipped()
                            .scaleEffect(self.scaleEffect(for: geometry))
                    } placeholder: {
                        ProgressView()
                            .frame(width: UIScreen.main.bounds.width / 2)
//                        Image("tree")
//                            .resizable()
//                            .scaledToFill()
//                            .frame(width: UIScreen.main.bounds.width / 2)
//                            .clipped()
//                            .shadow(radius: 5)
//                            .scaleEffect(self.scaleEffect(for: geometry))
                    }

                    
//                    Text("Name").padding(8).foregroundColor(.black).lineLimit(1).background(.thinMaterial).clipShape(Capsule()).minimumScaleFactor(0.5).offset(y: CGFloat(-30))
                }
            }
        }
        .frame(width: UIScreen.main.bounds.width / 2, height: imageHeight) //
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
//    static let viewHeight: CGFloat = 400
    static let imageHeight: CGFloat = 360
    
}

struct CarouselDetailView_Previews: PreviewProvider {
    static var previews: some View {
        CarouselDetailView(imageNames: ["phone", "tree", "phone"])
    }
}
