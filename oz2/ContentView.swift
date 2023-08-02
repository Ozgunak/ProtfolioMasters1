//
//  ContentView.swift
//  oz2
//
//  Created by özgün aksoy on 2023-07-25.
//

import SwiftUI

struct ContentView: View {
    @State private var currentTab: Tabs = .home
    @Namespace var animation
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(.darkGray)
                    .ignoresSafeArea()
                VStack(alignment: .leading) {
                    ScrollView(showsIndicators: false) {
                        AppHeaderView()
                        
                        switch currentTab {
                        case .home:
                            FlowScreen(flowItems: profiles)
                        case .inspect:
                            ProfileScreen()
                        case .explore:
                            ExploreView()
                        case .profile:
                            Text("profile")
                        }
                    }
                        Spacer()
                        TabBar()
                    }
            }
        }
    }
        
    @ViewBuilder
    func TabBar()->some View {
        
        HStack(spacing: 0) {
            ForEach(Tabs.allCases, id: \.rawValue) { tab in
                VStack(spacing: -2) {
                    Image(systemName: tab.rawValue)
                        .renderingMode(.template)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 28, height: 28)
                        .foregroundColor(currentTab == tab ? .white : .gray.opacity(0.6))
                    if currentTab == tab {
                        Circle()
                            .fill(.white)
                            .frame(width: 5, height: 5)
                            .offset(y: 10)
                            .matchedGeometryEffect(id: "TAB", in: animation)
                    }
                }
                .frame(maxWidth: .infinity)
                .contentShape(Rectangle())
                .onTapGesture {
                    withAnimation(.easeInOut) { currentTab = tab }
                }
            }
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


struct AppHeaderView: View {
    var body: some View {
        VStack {
            HStack {
                Text("Portfolio Masters").font(.title).foregroundColor(.white).padding(.horizontal)
                Spacer()
                Image(systemName: "person").foregroundColor(.white).padding().background(.thinMaterial).clipShape(Circle()).padding(.horizontal)
            }
            Color(.gray).frame(width: .infinity, height: 3)
        }
    }
}
