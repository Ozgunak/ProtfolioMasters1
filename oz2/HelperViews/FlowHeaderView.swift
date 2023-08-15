//
//  FlowHeaderView.swift
//  oz2
//
//  Created by özgün aksoy on 2023-08-13.
//

import SwiftUI

struct FlowHeaderView: View {
    @State var name: String
    @State var title: String
    @State var country: String
    @State var profileImage: String
    
    var body: some View {
        HStack {
            if !profileImage.isEmpty {
                AsyncImage(url: URL(string: profileImage)) { image in
                    image
                        .resizable()
                        .scaledToFill()

                        .frame(width: 50, height: 50)
                    
                        .clipShape(Circle())
                        .overlay {
                            Circle()
                                .stroke(lineWidth: 2)
                                .opacity(0.2)
                        }
                } placeholder: {
                    ProgressView()
                        .frame(width: 50, height: 50)
                }
            } else {
                Image(systemName: "person")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
                    .scaledToFill()
                    .overlay {
                        Circle()
                            .stroke(lineWidth: 2)
                            .opacity(0.2)
                    }

            }
            VStack(alignment: .leading) {
                Text(name).font(.callout).fontWeight(.semibold).lineLimit(1)
                HStack() {
                    Text(title).font(.caption)
                    Text(country).font(.caption)
                }.lineLimit(1)
            }
        }
    }
}

struct FlowHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        List(0..<1) { item in
            FlowHeaderView(name: "Ozg", title: "iOS", country: "Ca", profileImage: "https://firebasestorage.googleapis.com:443/v0/b/portfoliomasters1.appspot.com/o/Gdweig942hVPzQfu3fP1%2F86DEB1AE-744D-4B66-A79B-E618560AFCF1.jpeg?alt=media&token=3c882cbd-6713-42ca-8f18-7d5e573a67d5")
            FlowHeaderView(name: "Ozg", title: "iOS", country: "Ca", profileImage: "")
        }
    }
}
