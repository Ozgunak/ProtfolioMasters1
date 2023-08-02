//
//  ExploreView.swift
//  oz2
//
//  Created by özgün aksoy on 2023-08-01.
//

import SwiftUI

struct ExploreView: View {
    @State private var searchText = ""
    var body: some View {
        ZStack {
            Color(.darkGray).ignoresSafeArea()
            ScrollView(showsIndicators: false) {
                VStack {
                    TextField("Search User, Project or Title", text: $searchText).textFieldStyle(.roundedBorder).padding().shadow(radius: 3)
                    ForEach(/*@START_MENU_TOKEN@*/0 ..< 5/*@END_MENU_TOKEN@*/) { item in
                        FlowItemView(profile: UserProfile(name: "oz", title: "iOS", country: "CA")).padding()
                    }
                }
            }
        }
    }
}

struct ExploreView_Previews: PreviewProvider {
    static var previews: some View {
        ExploreView()
    }
}
