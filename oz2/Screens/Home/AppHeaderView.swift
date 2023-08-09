//
//  AppHeaderView.swift
//  oz2
//
//  Created by özgün aksoy on 2023-08-07.
//

import SwiftUI

struct AppHeaderView: View {
    @State var isNewUser: Bool
    @State private var isSheetPresented = false
    var body: some View {
        VStack {
            HStack {
                Text("Portfolio Masters").font(.title).foregroundColor(.white).padding(.horizontal)
                Spacer()
                if isNewUser {
                    Button {
                        isSheetPresented.toggle()
                    } label: {
                        Image(systemName: "person").foregroundColor(.white).padding().background(.thinMaterial).clipShape(Circle()).padding(.horizontal)
                    }
                } else {
                    NavigationLink(destination: MyProfileScreen().environmentObject(MyProfileViewModel())) {
                        Image(systemName: "person").foregroundColor(.white).padding().background(.thinMaterial).clipShape(Circle()).padding(.horizontal)
                    }
                }
                

            }
            Color(.gray).frame(width: .infinity, height: 3)
        }
        .sheet(isPresented: $isSheetPresented) {
            NavigationStack {
                NewProfileView()
            }
        }
    }
}

struct AppHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        AppHeaderView(isNewUser: true).background(.gray)
    }
}
