//
//  FIrestoreManager.swift
//  oz2
//
//  Created by özgün aksoy on 2023-08-17.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseStorage



final class FirestoreManager {
    
    static let shared = FirestoreManager()
    private init() {}
    
    private let userCollection = Firestore.firestore().collection("users")
    
    func createUser(user: DBUser) async throws {
        try userCollection.document(user.userId).setData(from: user)
    }
    
    func getUser(userID: String) async throws -> DBUser {
        return try await userCollection.document(userID).getDocument(as: DBUser.self)
    }
    
    func createProject(profileID: String, project: ProjectModel, images: [UIImage?]) async throws -> Bool {
        let db = Firestore.firestore()
        print("Project save init")

        let userProfile = try await getUser(userID: profileID)
        
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
        
        if !images.isEmpty {
            let storage = Storage.storage() // Create a Firebase Storage instance
            var imageList: [String] = []

            // MARK: Save images to store
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
            
            // second way save image names on project file
            
            let projString = "flowItem/\(profileID)/projects"
            
            var newProj = FlowItemModel(id: refID,
                                        name: userProfile.name ?? "New User",
                                        title: userProfile.title ?? "",
                                        projectName: project.name,
                                        description: project.description,
                                        detail: project.detail,
                                        profileID: profileID,
                                        progileImage: userProfile.photoURL ?? "",
                                        imageNames: imageList,
                                        owner: profileID)
            
            do {
                
                try await db.collection(projString).document(refID).setData(["imageNames": imageList], merge: true)
                print("😎 Data images updated successfully!")
                try await db.collection("projects").addDocument(data: newProj.dictionary)
                print("😎 Project with photos added to projects successfully!")
                return true
            } catch {
                print("😡 ERROR: Could not update data in 'imageNames' for profileID \(profileID)")
                return false
            }
        }
        else {
            var newProj = FlowItemModel(id: refID,
                                        name: userProfile.name ?? "New User",
                                        title: userProfile.title ?? "",
                                        projectName: project.name,
                                        description: project.description,
                                        detail: project.detail,
                                        profileID: profileID,
                                        progileImage: userProfile.photoURL ?? "",
                                        imageNames: project.imageNames,
                                        owner: profileID)
            try await db.collection("projects").addDocument(data: newProj.dictionary)
            print("😎 Project without photos added to projects successfully!")
        }
        return false
    }
}
