//
//  UserModel.swift
//  oz2
//
//  Created by özgün aksoy on 2023-08-02.
//

import SwiftUI

struct UserModel: Codable, Identifiable {

    var id: String
    var userName: String
    var email: String
    var country: String
    var title: String
    var aboutMe: String
    var bio: String
    var experience: String
    var projects: [String]
    var followers: [String]
    var following: [String]
    var doneDeals: [String]
    var isPremiumCostumer: Bool
    var profilePhoto: String
    
    init(id: String, userName: String, email: String, country: String, title: String, aboutMe: String, bio: String, experience: String, projects: [String], followers: [String], following: [String], doneDeals: [String], isPremiumCostumer: Bool, profilePhoto: String) {
        self.id = id
        self.userName = userName
        self.email = email
        self.country = country
        self.title = title
        self.aboutMe = aboutMe
        self.bio = bio
        self.experience = experience
        self.projects = projects
        self.followers = followers
        self.following = following
        self.doneDeals = doneDeals
        self.isPremiumCostumer = isPremiumCostumer
        self.profilePhoto = profilePhoto
    }
    
}
