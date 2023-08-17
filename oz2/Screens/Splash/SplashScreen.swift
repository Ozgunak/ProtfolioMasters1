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
    @State private var showSigninView: Bool = false
    
    var body: some View {
        ZStack {
            if !showSigninView {
                FlowListView(showLoginView: $showSigninView)
            }
        }
        .onAppear {
            let user = try? AuthenticationManager.shared.getAuthUser()
            self.showSigninView = user == nil
        }
        .fullScreenCover(isPresented: $showSigninView) {
            LoginView(showLoginView: $showSigninView)
        }
    }
}

struct SplashScreen_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreen()
    }
}
