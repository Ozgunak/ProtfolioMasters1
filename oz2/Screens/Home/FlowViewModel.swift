//
//  FlowViewModel.swift
//  oz2
//
//  Created by özgün aksoy on 2023-08-07.
//

import Foundation

class FlowViewModel: ObservableObject {
    @Published var flowItems: [UserProfileModel] = []
    
    init() {
        flowItems.append(UserProfileModel(name: "Oz Aksoy", title: "iOS Developer", country: "CA", projects: projects))
        flowItems.append(UserProfileModel(name: "Zey Aksoy", title: "iOS Developer", country: "CA", projects: projects))
    }
    
    func saveUserProfile() {
        
    }
    
    func editUserProfile() {
        
    }
    
    func deleteUserProfile() {
        
    }
    
    func blockUserProfile() {
        
    }
}
