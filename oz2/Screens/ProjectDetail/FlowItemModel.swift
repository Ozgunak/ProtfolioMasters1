//
//  FlowItemModel.swift
//  oz2
//
//  Created by özgün aksoy on 2023-08-15.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

struct FlowItemModel : Hashable, Identifiable, Codable {
    @DocumentID var id: String?
    var name: String = ""
    var title: String = ""
    var projectName: String = ""
    var description: String = ""
    var detail: String  = ""
    var profileID: String = ""
    var progileImage: String = ""
    var imageNames: [String] = []
    var owner: String = Auth.auth().currentUser?.uid ?? ""

    var dictionary:  [String: Any] {
        return ["name": name,
                "title": title,
                "projectName": projectName,
                "description": description,
                "detail": detail,
                "profileID": profileID,
                "progileImage": progileImage,
                "imageNames": imageNames,
                "owner": owner,
                "postedOn": Timestamp(date: Date.now)]
    }
}
