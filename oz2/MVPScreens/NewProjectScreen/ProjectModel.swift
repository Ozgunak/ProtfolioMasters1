//
//  ProjectModel.swift
//  oz2
//
//  Created by özgün aksoy on 2023-08-02.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

struct ProjectModel : Hashable, Identifiable, Codable {
    @DocumentID var id: String?
    var name: String = ""
    var description: String = ""
//    var tech: [String]  = []
//    var developmentTime: String?
    var imageNames: [String] = []
    var detail: String  = ""
    var owner: String = Auth.auth().currentUser?.uid ?? ""

    var dictionary:  [String: Any] {
        return ["name": name, "description": description, "imageNames": imageNames, "detail": detail, "owner": owner, "postedOn": Timestamp(date: Date.now)]
    }
}



