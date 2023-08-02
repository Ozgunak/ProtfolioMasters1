//
//  Login.swift
//  oz2
//
//  Created by özgün aksoy on 2023-08-02.
//

import SwiftUI
import AuthenticationServices

struct LoginView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(spacing: 20) {
            Image("plusButton")
            Text("Welcome! \nPlease sign in:")
                .font(.headline)
                .multilineTextAlignment(.center)
            
            SignInWithAppleButton(.signIn, onRequest: { request in
                request.requestedScopes = [.fullName, .email]
            }, onCompletion: { result in
                switch result {
                case .success(let authResults):
                    // Handle success
                    print(authResults)
                case .failure(let error):
                    // Handle error
                    print(error.localizedDescription)
                }
            })
            .frame(height: 45)
            .cornerRadius(10)
            
//            GoogleSignInButton()
//                .frame(height: 45)
//                .cornerRadius(10)
            
            Button("Sign in with Email") {
                // Handle email sign-in
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .padding()
    }
}


struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
