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
        
    func saveProjectWithImage(profile: FlowModel, project: ProjectModel, projectPhotos: ProjectPhotos, images: [UIImage?]) async -> Bool {
        let db = Firestore.firestore()
        print("Project save init")
        guard let profileID = profile.id else {
            print("😡 ERROR: Could not get profile or flow id")
            return false
        }
        var refID = project.id ?? ""
        
        // if id nil create new id
        if refID == "" {
            do {
                let collectionString = "flowItem/\(profileID)/projects"
                
                let docRef = try await db.collection(collectionString).addDocument(data: project.dictionary)
                refID = docRef.documentID
                print("succesfully created project ID")
            } catch {
                print("Error: creating project ID \(error.localizedDescription)")
            }
            
        }
        
        
        // MARK: Save photo to storage

        let storage = Storage.storage() // Create a Firebase Storage instance
        var imageList: [String] = []
        
        if !images.isEmpty {
            var newImages = images.filter( {$0 != nil })
            for image in newImages {
                var photoName = UUID().uuidString // This will be the name of the image file
                let storageRef = storage.reference().child("\(profileID)/\(refID)/\(photoName).jpeg")
                guard let resizedImage = image?.jpegData(compressionQuality: 0.2) else {
                    print("😡 ERROR: Could not resize image")
                    return false
                }
                
                let metadata = StorageMetadata()
                metadata.contentType = "image/jpg" // Setting metadata allows you to see console image in the web browser. This seteting will work for png as well as jpeg
                var imageURLString = "" // We'll set this after the image is successfully saved
                
                do {
                    let _ = try await storageRef.putDataAsync(resizedImage, metadata: metadata)
                    print("📸 Project Image Saved!")
                    do {
                        let imageURL = try await storageRef.downloadURL()
                        imageURLString = "\(imageURL)" // We'll save this to Cloud Firestore as part of document in 'photos' collection, below
                        imageList.append(imageURLString)
                    } catch {
                        print("😡 ERROR: Could not get imageURL after saving image \(error.localizedDescription)")
                        return false
                    }
                } catch {
                    print("😡 ERROR: uploading image to FirebaseStorage")
                    return false
                }
            }
            
            
            // Now save to the "photos" collection of the spot document "spotID"
//            let projectString = "flowItem/\(profileID)/projects/\(refID)/photos"
//            
//            do {
//                var newProjectPhotos = projectPhotos
//                newProjectPhotos.photoList = imageList
//                try await db.collection(projectString).addDocument(data: newProjectPhotos.dictionary)
//                print("😎 Data updated successfully!")
//                return true
//            } catch {
//                print("😡 ERROR: Could not update data in 'photos' for profileID \(profileID) for project \(refID)")
//                return false
//            }
            
            // second way save image names on project file
            
            let projString = "flowItem/\(profileID)/projects"
            
            var newProj = FlowItemModel(id: refID,
                                        name: profile.name,
                                        title: profile.title,
                                        projectName: project.name,
                                        description: project.description,
                                        detail: project.detail,
                                        profileID: profileID,
                                        progileImage: profile.profileImage,
                                        imageNames: imageList,
                                        owner: profile.owner)
            
            do {
                
                try await db.collection(projString).document(refID).setData(["imageNames": imageList], merge: true)
                print("😎 Data images updated successfully!")
                try await db.collection("projects").addDocument(data: newProj.dictionary)
                print("😎 Project added to projects successfully!")
                return true
            } catch {
                print("😡 ERROR: Could not update data in 'imageNames' for profileID \(profileID)")
                return false
            }
        }
        return false
    }
    
    
    
}
