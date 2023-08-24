//
//  LoginViewModel.swift
//  oz2
//
//  Created by özgün aksoy on 2023-08-09.
//

import Foundation

@MainActor
class LoginViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    
    func signUp() async throws {
        let authResult = try await AuthenticationManager.shared.createUser(email: email, password: password)
        let user = DBUser(auth: authResult)
        try await FirestoreManager.shared.createUser(user: user)
    }
    
    func signIn() async throws {
        try await AuthenticationManager.shared.signIn(email: email, password: password)
    }
    
    func signInAnonymous() async throws {
        let authResult = try await AuthenticationManager.shared.createAnonymousUser()
        let user = DBUser(auth: authResult)
        try await FirestoreManager.shared.createUser(user: user)
    }
    
    func isValidInput() -> Bool {
        let emailText = (email.count > 5 && email.contains("@"))
        let passText = (password.count > 5)
        return !(emailText && passText)
    }
}

 
