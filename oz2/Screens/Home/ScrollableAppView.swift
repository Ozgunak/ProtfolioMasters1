//
//  ScrollableAppView.swift
//  oz2
//
//  Created by özgün aksoy on 2023-07-29.
//

import SwiftUI

struct ScrollableAppView: View {
    var body: some View {
        VStack {
            Text("Example Apps")
                .font(.title2)
                .padding(.bottom, 4)
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(content: {
                    ForEach(1...10, id: \.self) { count in
                        //                            NavigationLink(destination: DetailView2()) {
                        VStack {
                            Image("phoneScreen").resizable().aspectRatio(contentMode: .fill)
                            Text("App \(count)")
                        }
                        .frame(width: 100)
                        .padding(4)
                        
                        //                            }
                    }
                })
            }
            .frame(height: 250)
        }
        .padding(.vertical)
        .background(.thinMaterial)
        .cornerRadius(20)
        .shadow(radius: 2)
    }
}

struct ScrollableAppView_Previews: PreviewProvider {
    static var previews: some View {
        ScrollableAppView()
    }
}
