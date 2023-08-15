//
//  SplashScreen.swift
//  oz2
//
//  Created by özgün aksoy on 2023-08-02.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift


struct SplashScreen: View {
    @State private var loginSheetPresented: Bool = false
    @State private var mainPresented: Bool = false
    
    
    

    var body: some View {
        ZStack {
            Color(.darkGray).ignoresSafeArea()
            VStack {
                Image("plusButton").clipShape(Circle())
            }
            .onAppear {
                if Auth.auth().currentUser?.email != nil {
                    mainPresented.toggle()
                    // login successfull
                    
                } else {
                    loginSheetPresented.toggle()
                }
            }
            .fullScreenCover(isPresented: $loginSheetPresented) {
                LoginView()
            }
//            .fullScreenCover(isPresented: $mainPresented) {
//                FlowListView()
//            }
        }
    }
}

struct SplashScreen_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreen()
    }
}
