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
        try await AuthenticationManager.shared.createUser(email: email, password: password)
    }
    
    func signIn() async throws {
        try await AuthenticationManager.shared.signIn(email: email, password: password)
    }
    
    func isValidInput() -> Bool {
        let emailText = (email.count > 5 && email.contains("@"))
        let passText = (password.count > 5)
        return !(emailText && passText)
    }
}

 
