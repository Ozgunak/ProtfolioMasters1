//
//  CarouselImage.swift
//  oz2
//
//  Created by özgün aksoy on 2023-08-08.
//

import SwiftUI

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
                VStack {
                    Image(imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: UIScreen.main.bounds.width / 3)
                        .clipped()
                        .shadow(radius: 5)
                    .scaleEffect(self.scaleEffect(for: geometry))
                    
                    Text("Name").padding(8).foregroundColor(.white).multilineTextAlignment(.center).background(.thinMaterial).clipShape(Capsule())
                }
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
    static let viewHeight: CGFloat = 400
    static let imageHeight: CGFloat = 360
    
}

struct CarouselDetailView_Previews: PreviewProvider {
    static var previews: some View {
        CarouselDetailView(imageNames: ["phone", "phone"])
    }
}
