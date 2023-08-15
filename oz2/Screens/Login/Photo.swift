//
//  Photo.swift
//  oz2
//
//  Created by özgün aksoy on 2023-08-12.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

struct Photo: Identifiable, Codable, Hashable {
    @DocumentID var id: String?
    var imageURLString: String = ""
    var owner = Auth.auth().currentUser?.email ?? ""
    var postedOn = Date()
    
    var dictionary: [String: Any] {
        return ["imageURLString": imageURLString, "owner": owner, "postedOn": Timestamp(date: Date())]
    }
}
