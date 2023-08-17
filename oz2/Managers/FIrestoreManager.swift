//
//  FIrestoreManager.swift
//  oz2
//
//  Created by özgün aksoy on 2023-08-17.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

final class FirestoreManager {
    
    static let shared = FirestoreManager()
    private init() {}
    
    func createUser(auth: AuthDataResultModel) async throws {
        var userData: [String: Any] = [
            "user_id": auth.uid,
            "is_anonymous": auth.isAnonymous,
            "date_created": Timestamp(),
        ]
        if let email = auth.email {
            userData["email"] = email
        }
        if let photoURL = auth.photoURL {
            userData["photoURL"] = photoURL
        }
        
        try await Firestore.firestore().collection("users").document(auth.uid).setData(userData)
    }
}
