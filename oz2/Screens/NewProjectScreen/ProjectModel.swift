//
//  ProjectModel.swift
//  oz2
//
//  Created by özgün aksoy on 2023-08-02.
//

import Foundation



struct ProjectModel : Hashable, Identifiable, Codable {
    var id = UUID().uuidString
    var name: String
    var description: String
    var tech: [String]
    var developmentTime: String?
    var imageNames: [String]?
    var detail: String?
    
}
