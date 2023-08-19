//
//  FlowModel.swift
//  oz2
//
//  Created by özgün aksoy on 2023-08-09.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift
struct FlowModel: Identifiable, Codable {
    @DocumentID var id: String?
    var name: String = ""
    var title: String = ""
    var owner: String = Auth.auth().currentUser?.uid ?? ""
    var profileImage: String = ""
    
    var dictionary:  [String: Any] {
        return ["name": name, "title": title, "profileImage": profileImage, "owner": owner]
    }
}
