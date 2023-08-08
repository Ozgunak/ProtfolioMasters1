//
//  UserProfileModel.swift
//  oz2
//
//  Created by özgün aksoy on 2023-08-07.
//

import Foundation

struct UserProfileModel: Identifiable, Hashable, Codable {
    var id = UUID().uuidString
    var name: String
    var title: String
    var country: String
    var profileImage: String?
    var projects: [ProjectModel]?
}
