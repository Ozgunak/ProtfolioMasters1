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
        flowItems.append(UserProfileModel(id: UUID().uuidString, name: "Oz Aksoy", title: "iOS Developer", country: "CA", projects: testProjects))
        flowItems.append(UserProfileModel(id: UUID().uuidString, name: "Zey Aksoy", title: "Data Analyzer", country: "CA", projects: testProjects))
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
