//
//  Login.swift
//  oz2
//
//  Created by özgün aksoy on 2023-08-02.
//

import SwiftUI
import AuthenticationServices
import Firebase

struct LoginView: View {
    @State private var email: String = "1@2.com"
    @State private var password: String = "123qwe"
    @State private var isAlertShowing: Bool = false
    @State private var alertMessage: String = ""
    @State private var showContext: Bool = false

    var body: some View {
        ZStack {
            Color(.darkGray).ignoresSafeArea()
            
            VStack(spacing: 20) {
                Image("plusButton")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .cornerRadius(20)
                Text("Welcome! \nPlease sign in:")
                    .font(.headline)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                
                //            SignInWithAppleButton(.signIn, onRequest: { request in
                //                request.requestedScopes = [.fullName, .email]
                //            }, onCompletion: { result in
                //                switch result {
                //                case .success(let authResults):
                //                    // Handle success
                //                    print(authResults)
                //                case .failure(let error):
                //                    // Handle error
                //                    print(error.localizedDescription)
                //                }
                //            })
                //            .frame(height: 45)
                //            .cornerRadius(10)
                
                //            GoogleSignInButton()
                //                .frame(height: 45)
                //                .cornerRadius(10)
                
                Group {
                    TextField("E-Mail", text: $email)
                        .keyboardType(.emailAddress)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                        .padding(.horizontal)
                        .padding(.vertical, 4)
                    SecureField("Password", text: $password)
                        .padding(.horizontal)
                        .padding(.vertical, 4)
                }
                .textFieldStyle(.plain)
                .overlay {
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(lineWidth: 1)
                }
                .background(.white)
                .cornerRadius(4)
                
                
                HStack {
                    Button("Sign-Up") {
                        signUp()
                    }
                    .padding()
                    .background(.thickMaterial)
                    .cornerRadius(10)
                    
                    Button("Log In") {
                        logIn()
                    }
                    .padding()
                    .background(.thickMaterial)
                    .cornerRadius(10)
                }
                .foregroundColor(.black)
                .tint(.white)
            }
            .padding()
            .alert(alertMessage, isPresented: $isAlertShowing) {
                Button("OK", role: .cancel) {}
            }
            .fullScreenCover(isPresented: $showContext) {
                ContentView()
            }
            
        }
    }
    
    func signUp() {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error {
                print("Error Sign-Up: \(error.localizedDescription)")
                alertMessage = "Error Sign-Up: \(error.localizedDescription)"
                isAlertShowing.toggle()
            } else {
                print("Successfully Signed Up")
                showContext = true
            }
        }
    }
    
    func logIn() {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error {
                print("Error Log-In: \(error.localizedDescription)")
                alertMessage = "Error Log-In: \(error.localizedDescription)"
                isAlertShowing.toggle()
            } else {
                print("Successfully Signed In")
                showContext = true
            }
        }
    }

}


struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
