//
//  FlowScreen.swift
//  oz2
//
//  Created by özgün aksoy on 2023-08-01.
//

import SwiftUI

struct FlowScreen: View {
    @EnvironmentObject var flowVM: FlowViewModel
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            
            VStack(alignment: .leading) {
                
                AppHeaderView(isNewUser: false)
                
                Text("Featured Portfolios").foregroundColor(.white).padding(.horizontal)
                
                ForEach(flowVM.flowItems) { profile in
                    NavigationLink(destination: UsersProfileScreen(user: profile).environmentObject(MyProfileViewModel())) {
                        FlowItemView(profile: profile).padding(.horizontal)
                    }
                }
            }
            
        }
    }
}

struct FlowScreen_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ZStack {
                Color(.darkGray)
                    .ignoresSafeArea()
                FlowScreen()
                    .environmentObject(FlowViewModel())
            }
        }
    }
}

struct FlowItemView: View {
    @State var profile: UserProfileModel
    var body: some View {
        VStack(alignment: .leading) {
            FlowHeaderView(name: $profile.name, title: $profile.title, country: $profile.country)
            FlowImageView(projects: $profile.projects)
            Text("Last Active: 5 mins ago").font(.caption)
        }.padding().background(.thinMaterial).cornerRadius(10)
    }
}

struct FlowHeaderView: View {
    @Binding var name: String
    @Binding var title: String
    @Binding var country: String
    
    var body: some View {
        HStack {
            Image(systemName: "person").padding().background(.thinMaterial).clipShape(Circle())
            VStack(alignment: .leading) {
                Text(name).font(.callout).fontWeight(.semibold)
                HStack() {
                    Text(title).font(.caption)
                    Text(country).font(.caption)
                }
            }
        }
    }
}

struct FlowImageView: View {
    @Binding var projects: [ProjectModel]?
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                if projects != nil && !(projects!.isEmpty) {
                    ForEach(projects!) { item in
                        Image(item.imageNames?.first ?? "phone").resizable().scaledToFit().cornerRadius(20)
                    }
                } else {
                    ForEach(0 ..< 5) { item in
                        Image("phone").resizable().scaledToFit().cornerRadius(20)
                    }
                    // TODO: Insert Placeholder
                }
            }
        }.frame(height: 400)
    }
}


