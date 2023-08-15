//
//  ProfileScreen.swift
//  oz2
//
//  Created by özgün aksoy on 2023-07-29.
//

import SwiftUI

struct MyProfileScreen: View {
    @State private var isSheetPresented = false
    @State var user: UserProfileModel?
    @EnvironmentObject var profileVM: MyProfileViewModel
    //    private var selfUser: Bool = false
    // TODO: Replace with self profile
    var body: some View {
        ZStack {
            Color(.darkGray).ignoresSafeArea()
            
            VStack {
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .center) {
                        HStack {
                            Text(profileVM.myProfile.name)
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
                        Text(profileVM.myProfile.title)
                            .font(.caption)
                            .foregroundColor(.white)
                            .padding()
                            .cornerRadius(20)
                            .shadow(radius: 2)
                        Button {
                            isSheetPresented.toggle()
                        } label: {
                            Text("Edit").foregroundColor(.white).padding().background(.thinMaterial).cornerRadius(20)
                        }

                    }
                    VStack(alignment: .leading) {
//                        CarouselView(projects1: $profileVM.myProfile.projects)
                        InfoView().padding(.horizontal)
                    }
                }
            }
        }
//        .navigationTitle(profileVM.profile.name).foregroundColor(.white).tint(.white)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    isSheetPresented = true
                } label: {
                    Image(systemName: "pencil.circle")
                }
            }
        }
        .sheet(isPresented: $isSheetPresented, onDismiss: profileVM.loadProfile) {
            NavigationStack {
                NewProfileView().environmentObject(MyProfileViewModel())
            }
        }
    }
}

struct MyProfileScreen_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            MyProfileScreen(user: UserProfileModel(name: "o", title: "a"))
                .environmentObject(MyProfileViewModel())
        }
    }
}








