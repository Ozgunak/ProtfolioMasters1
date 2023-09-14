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
    
    func getUser(userID: String) async throws -> DBUser {
        return try await userCollection.document(userID).getDocument(as: DBUser.self)
    }
    
    func createUser(user: DBUser) async throws {
        try userCollection.document(user.userId).setData(from: user)
    }
    
    func updateUser(userID: String, profileModel: UserProfileModel) async throws {
        let data: [String:Any] = [
            DBUser.CodingKeys.name.stringValue: profileModel.name,
            DBUser.CodingKeys.title.stringValue: profileModel.title,
            DBUser.CodingKeys.aboutMe.stringValue: profileModel.aboutMe,
            DBUser.CodingKeys.country.stringValue: profileModel.country,
            DBUser.CodingKeys.profileImageUrl.stringValue: profileModel.profileImageUrl,
            DBUser.CodingKeys.githubURL.stringValue: profileModel.githubURL,
            DBUser.CodingKeys.linkedInURL.stringValue: profileModel.linkedInURL,
            DBUser.CodingKeys.twitterURL.stringValue: profileModel.twitterURL,
            DBUser.CodingKeys.facebookURL.stringValue: profileModel.facebookURL,
            DBUser.CodingKeys.instagramURL.stringValue: profileModel.instagramURL,
            DBUser.CodingKeys.personalWebsiteURL.stringValue: profileModel.personalWebsiteURL
        ]
        
        try await userCollection.document(userID).updateData(data)
    }
    
    func updateUserProfileImagePath(userId: String, path: String?, url: String?) async throws {
        let data: [String:Any] = [
            DBUser.CodingKeys.profileImagePath.rawValue : path,
            DBUser.CodingKeys.profileImageUrl.rawValue : url,
        ]

        try await userCollection.document(userId).updateData(data)
    }
    
    // MARK: Skill CRUD
    func createUserSkill(userID: String, skillModel: SkillModel) async throws {
        try await userCollection.document(userID).collection("skills").addDocument(data: skillModel.dictionary)
    }
    
    func getUserSkill(userID: String) async throws -> [SkillModel] {
        return try await userCollection.document(userID).collection("skills").order(by: "yearsOfExperience", descending: true).getDocuments(as: SkillModel.self)
    }
    
    func deleteSkill(userID: String, skillID: String) {
        userCollection.document(userID).collection("skills").document(skillID).delete() { error in
            if let error {
                print("Error: deleting skills \(error.localizedDescription)")
            } else {
                print("succesfully deleted skill")
            }
        }
    }
    // MARK: Experience CRUD

    func createUserExperience(userID: String, experienceModel: ExperienceModel) async throws {
        try await userCollection.document(userID).collection("experiences").addDocument(data: experienceModel.dictionary)
    }
    
    func getUserExperience(userID: String) async throws -> [ExperienceModel] {
        return try await userCollection.document(userID).collection("experiences").getDocuments(as: ExperienceModel.self)
    }
    
    func deleteExperience(userID: String, experienceID: String) {
        userCollection.document(userID).collection("experiences").document(experienceID).delete() { error in
            if let error {
                print("Error: deleting experiences \(error.localizedDescription)")
            } else {
                print("succesfully deleted experience")
            }
        }
    }
    
    // MARK: Cover Project CRUD

    func createUserCoverProject(userID: String, coverProjectModel: CoverProjectModel) async throws {
        try await userCollection.document(userID).collection("projects").addDocument(data: coverProjectModel.dictionary)
    }
    
    func getUserCoverProject(userID: String) async throws -> [CoverProjectModel] {
        return try await userCollection.document(userID).collection("projects").order(by: "publishTime", descending: true).getDocuments(as: CoverProjectModel.self)
    }
    
    func deleteCoverProject(userID: String, projectID: String) {
        userCollection.document(userID).collection("projects").document(projectID).delete() { error in
            if let error {
                print("Error: deleting projects \(error.localizedDescription)")
            } else {
                print("succesfully deleted project")
            }
        }
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
                let storageRef = storage.reference().child("projects/\(profileID)/\(refID)/\(photoName).jpeg")
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
            
            try await createUserCoverProject(userID: profileID, coverProjectModel: CoverProjectModel(projectName: project.name, image: imageList.first ?? "", keywords: "", isStillWorking: false, details: project.description))
            
            // save image names on project file
            
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
