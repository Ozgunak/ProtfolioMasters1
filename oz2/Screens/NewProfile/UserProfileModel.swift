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
                images.append(project.imageNames.first ?? "phone")
            }
            return images
        }
        return []
    }
}

struct DBUser: Codable  {
    var userId: String
    var isAnonymous: Bool?
    var dateCreated: Date?
    var email: String?
    var photoURL: String?
    var displayName: String?
    var name: String? = ""
    var title: String? = ""
    var aboutMe: String? = ""
    var country: String? = "Canada"
    var profileImageUrl: String? = ""
    var githubURL: String? = ""
    var linkedInURL: String? = ""
    var twitterURL: String? = ""
    var facebookURL: String? = ""
    var instagramURL: String? = ""
    var personalWebsiteURL: String? = ""
    
    
    init(userId: String, isAnonymous: Bool? = nil, dateCreated: Date? = nil, email: String? = nil, photoURL: String? = nil, displayName: String? = nil, name: String? = nil, title: String? = nil, aboutMe: String? = nil, country: String? = nil, profileImageUrl: String? = nil, githubURL: String? = nil, linkedInURL: String? = nil, twitterURL: String? = nil, facebookURL: String? = nil, instagramURL: String? = nil, personalWebsiteURL: String? = nil) {
        self.userId = userId
        self.isAnonymous = isAnonymous
        self.dateCreated = dateCreated
        self.email = email
        self.photoURL = photoURL
        self.displayName = displayName
        self.name = name
        self.title = title
        self.aboutMe = aboutMe
        self.country = country
        self.profileImageUrl = profileImageUrl
        self.githubURL = githubURL
        self.linkedInURL = linkedInURL
        self.twitterURL = twitterURL
        self.facebookURL = facebookURL
        self.instagramURL = instagramURL
        self.personalWebsiteURL = personalWebsiteURL
    }
    
    init(auth: AuthDataResultModel) {
        self.userId = auth.uid
        self.email = auth.email
        self.isAnonymous = auth.isAnonymous
        self.dateCreated = Date()
        self.photoURL = auth.photoURL
        self.displayName = auth.displayName
    }
    
    enum CodingKeys: String, CodingKey {
        case userId
        case isAnonymous
        case dateCreated
        case email
        case photoURL
        case displayName
        case name
        case title
        case aboutMe
        case country
        case profileImageUrl
        case githubURL
        case linkedInURL
        case twitterURL
        case facebookURL
        case instagramURL
        case personalWebsiteURL
    }
}
