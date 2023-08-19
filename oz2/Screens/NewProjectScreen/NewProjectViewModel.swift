//
//  NewProjectViewModel.swift
//  oz2
//
//  Created by özgün aksoy on 2023-08-08.
//

import Foundation
import FirebaseStorage
import FirebaseFirestore

class NewProjectViewModel: ObservableObject {
    @Published var newProject = ProjectModel()
        
    func saveProjectWithImage(project: ProjectModel, projectPhotos: ProjectPhotos, images: [UIImage?]) async throws -> Bool {
        let user = try AuthenticationManager.shared.getAuthUser()
        return try await FirestoreManager.shared.createProject(profileID: user.uid, project: project, images: images)
    }
    
    
    
}
