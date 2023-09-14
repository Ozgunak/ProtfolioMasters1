//
//  NewProjectViewModel.swift
//  oz2
//
//  Created by özgün aksoy on 2023-08-08.
//

import Foundation
import FirebaseStorage
import FirebaseFirestore

@MainActor
class NewProjectViewModel: ObservableObject {
    @Published var newProject = ProjectModel()
        
    func saveProjectWithImage(project: ProjectModel, projectPhotos: ProjectPhotos, images: [UIImage?]) async throws -> Bool {
        let user = try AuthenticationManager.shared.getAuthUser()
        if let image = images.first, let coverImage = image, let imageName = project.id {
            LocalFileManager.instance.saveImage(image: coverImage, imageName: imageName, folderName: "projectImages")
            
        }
        return try await FirestoreManager.shared.createProject(profileID: user.uid, project: project, images: images)
    }
    
    
    
}
