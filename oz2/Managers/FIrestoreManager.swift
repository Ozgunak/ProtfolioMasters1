//
//  FIrestoreManager.swift
//  oz2
//
//  Created by özgün aksoy on 2023-08-17.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct DBUser: Codable  {
    var userId: String
    var isAnonymous: Bool?
    var dateCreated: Date?
    var email: String?
    var photoURL: String?
    
    init(auth: AuthDataResultModel) {
        self.userId = auth.uid
        self.email = auth.email
        self.isAnonymous = auth.isAnonymous
        self.dateCreated = Date()
        self.photoURL = auth.photoURL
    }
}

final class FirestoreManager {
    
    static let shared = FirestoreManager()
    private init() {}
    
    private let userCollection = Firestore.firestore().collection("users")
    
    func createUser(user: DBUser) async throws {
        try userCollection.document(user.userId).setData(from: user)
    }
    
    func getUser(userID: String) async throws -> DBUser {
        return try await userCollection.document(userID).getDocument(as: DBUser.self)
    }
}
