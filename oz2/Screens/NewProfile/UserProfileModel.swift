//
//  UserProfileModel.swift
//  oz2
//
//  Created by özgün aksoy on 2023-08-07.
//

import Foundation

struct UserProfileModel: Identifiable, Hashable, Codable {
    var id: String?
    var name: String
    var title: String
    var aboutMe: String = ""
    var country: String = "Canada"
    var profileImageUrl: String = ""
    var projects: [ProjectModel]?
    var githubURL: String = ""
    var linkedInURL: String = ""
    var twitterURL: String = ""
    var facebookURL: String = ""
    var instagramURL: String = ""
    var personalWebsiteURL: String = ""
    
    func toString() {
        print("name : \(name)\n title : \(title)\n about : \(aboutMe)\n time: \(Data())")
    }
    
    func projectImageList() -> [String] {
        if let projects {
            var images: [String] = []
            for project in projects {
                images.append(project.imageNames?.first ?? "phone")
            }
            return images
        }
        return []
    }
}
