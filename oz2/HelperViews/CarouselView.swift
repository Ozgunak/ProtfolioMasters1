//
//  CarouselView.swift
//  oz2
//
//  Created by özgün aksoy on 2023-08-08.
//

import SwiftUI

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
                ForEach(testProjects) { item in
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

struct CarouselView_Previews: PreviewProvider {
    static var previews: some View {
        CarouselView(projects1: .constant(testProjects))
    }
}
