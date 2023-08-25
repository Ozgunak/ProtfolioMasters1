//
//  ProfileScreen.swift
//  oz2
//
//  Created by özgün aksoy on 2023-07-29.
//

import SwiftUI
// View others profile screen

struct UsersProfileScreen: View {
    @State private var isLiked = false
    @State var user: UserProfileModel
//    @EnvironmentObject var profileVM: ProfileViewModel
    //    private var selfUser: Bool = false
    // TODO: Replace with self profile
    var body: some View {
        ZStack {
            Color(.darkGray).ignoresSafeArea()
            
            VStack {
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .center) {
                        HStack {
                            Text(user.name)
                                .padding()
                                .font(.headline)
                                .background(.thinMaterial)
                                .clipShape(Capsule())
                                .cornerRadius(20)
                                .shadow(radius: 10)
                            
                            Image("profileIcon")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 60, height: 60)
                                .clipShape(Circle())
                        }
                        Text(user.title)
                            .font(.caption)
                            .foregroundColor(.white)
                            .padding()
                            .cornerRadius(20)
                            .shadow(radius: 2)
                    }
                    VStack(alignment: .leading) {
                        
//                        CarouselDetailView(imageNames: user.projectImageList())
                        
//                        CarouselView(projects1: $user.projects)
//                        InfoView().padding(.horizontal)
                    }
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    // Like
                    isLiked.toggle()
                    // save id of profile to liked profile or like project
                } label: {
                    Image(systemName: isLiked ? "heart.fill" : "heart")
                }
            }
        }

    }
}

struct UsersProfileScreen_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            UsersProfileScreen(user: testProfile)
                .environmentObject(MyProfileViewModel())
        }
    }
}









