//
//  FlowListViewModel.swift
//  oz2
//
//  Created by özgün aksoy on 2023-08-09.
//

import Foundation
import FirebaseFirestoreSwift
import FirebaseFirestore

@MainActor
class FlowListViewModel: ObservableObject {
    @Published var flowItems: [FlowModel] = []
    @Published var user: DBUser?
    
    func loadCurrentUser() async throws {
        let authResult = try AuthenticationManager.shared.getAuthUser()
        self.user = try await FirestoreManager.shared.getUser(userID: authResult.uid)
    }
    
    
    func signout() throws {
        try AuthenticationManager.shared.signout()
    }

}
