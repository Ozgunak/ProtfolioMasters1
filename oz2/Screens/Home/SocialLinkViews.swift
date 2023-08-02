//
//  SocialLinkViews.swift
//  oz2
//
//  Created by özgün aksoy on 2023-07-29.
//

import SwiftUI

struct SocialLinkViews: View {
    var body: some View {
        HStack {
            Spacer()
            Link(destination: URL(string: "https://github.com/ozgunak")!) {
                Image("github")
                    .resizable()
                    .frame(width: 24, height: 24)
                Text("GitHub")
            }
            .padding()
            .background(.thinMaterial)
            .clipShape(Capsule())
            .shadow(radius: 10)
            Spacer()
            Link(destination: URL(string: "https://github.com/ozgunak")!) {
                Image("linkedin")
                    .resizable()
                    .frame(width: 24, height: 24)
                
                Text("LinkedIn")
            }
            .padding()
            
            .background(.thinMaterial)
            .clipShape(Capsule())
            .shadow(radius: 10)
            Spacer()
        }
    }
}

struct SocialLinkViews_Previews: PreviewProvider {
    static var previews: some View {
        SocialLinkViews()
    }
}
