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
    enum Field { case email, password }
    @State private var email: String = "1@2.com"
    @State private var password: String = "123qwe"
    @State private var isAlertShowing: Bool = false
    @State private var alertMessage: String = ""
    @State private var showContext: Bool = false
    @State private var buttonsDisabled: Bool = true
    @FocusState private var focusField: Field?
    
    @StateObject private var viewModel = LoginViewModel()
    @Binding var showLoginView: Bool

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
     
                // MARK: Text Fields
                Group {
                    TextField("E-Mail", text: $viewModel.email)
                        .keyboardType(.emailAddress)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                        .padding(.horizontal)
                        .padding(.vertical, 4)
                        .submitLabel(.next)
                        .focused($focusField, equals: .email)
                        .onSubmit {
                            focusField = .password
                        }
                        .onChange(of: viewModel.email) { _ in
                            let _ = viewModel.isValidInput()
                        }
                        .onAppear {
                            let _ = viewModel.isValidInput()
                        }
                    
                    
                    SecureField("Password", text: $viewModel.password)
                        .padding(.horizontal)
                        .padding(.vertical, 4)
                        .submitLabel(.done)
                        .focused($focusField, equals: .password)
                        .onSubmit {
                            focusField = .none
                        }
                        .onChange(of: viewModel.password) { _ in
                            let _ = viewModel.isValidInput()
                        }

                }
                .textFieldStyle(.plain)
                .overlay {
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(lineWidth: 1)
                }
                .background(.white)
                .cornerRadius(4)
                
                // MARK: Buttons
                
                
                Button {
                    Task{
                        do {
                            try await viewModel.signUp()
                            showLoginView = false
                            return
                        } catch {
                            print("Error 1: sign in \(error.localizedDescription)")
                            alertMessage = "Error: sign in \(error.localizedDescription)"
                        }
                        
                        do {
                            try await viewModel.signIn()
                            showLoginView = false
                            return
                        } catch {
                            print("Error 2: sign in \(error.localizedDescription)")
                            alertMessage = "Error: sign in \(error.localizedDescription)"
                        }
                        isAlertShowing = true

                    }
                } label: {
                    Text("Sign In With Email")
                        .disabled(viewModel.isValidInput())
                        .foregroundColor(.white)
                        .frame(height: 55)
                        .frame(maxWidth: .infinity)
                        .background(.blue)
                        .cornerRadius(10)
                        
                }
                
            }
            .padding()
            .alert(alertMessage, isPresented: $isAlertShowing) {
                Button("OK", role: .cancel) {}
            }
        }
        // MARK: On Appear
        .onAppear {
            if Auth.auth().currentUser != nil {
                showContext = true
            }
        }
    }
    
    func logIn() {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error {
                print("😡 Error Log-In: \(error.localizedDescription)")
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
        LoginView(showLoginView: .constant(true))
    }
}
