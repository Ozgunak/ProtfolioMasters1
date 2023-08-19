//
//  ProjDetailViewModel.swift
//  oz2
//
//  Created by özgün aksoy on 2023-08-10.
//

import Foundation
import FirebaseFirestore
import Firebase
import FirebaseStorage

class ProjDetailViewModel: ObservableObject {
    @Published var project = ProjModel()
    
    func saveProj(flow: FlowModel, project: ProjModel) async -> Bool {
        let db = Firestore.firestore()
        print("Proj save starts")
        guard let flowID = flow.id else {
            print("😡 Error could not get project id")
            return false
        }
        
        let collectionString = "flowItem/\(flowID)/projects"
        
        if let id = project.id {
            do {
                try await db.collection(collectionString).document(id).setData(project.dictionary)
                print("succesfully updated")
                return true
            } catch {
                print("😡 Error could not update data \(error.localizedDescription)")
                return false
            }
        } else {
            do {
                try await db.collection(collectionString).addDocument(data: project.dictionary)
                print("succesfully added")
                return true
            } catch {
                print("😡 Error could not update data \(error.localizedDescription)")
                return false
            }
        }
    }
    
    func saveImage(flow: FlowModel,project: ProjModel , photo: Photo, image: UIImage) async -> Bool {
        guard let flowID = flow.id else {
            print("😡 ERROR: flow.id == nil")
            return false
        }
        
        guard let projID = flow.id else {
            print("😡 ERROR: flow.id == nil")
            return false
        }
        
        var photoName = UUID().uuidString // This will be the name of the image file
        if photo.id != nil {
            photoName = photo.id! // I have a photo.id, so use this as the photoName. This happens if we're updating an existing Photo's descriptive info. It'll resave the photo, but that's OK. It'll just overwrite the existing one.
        }
        let storage = Storage.storage() // Create a Firebase Storage instance
        let storageRef = storage.reference().child("\(flowID)/\(photoName).jpeg")
        
        guard let resizedImage = image.jpegData(compressionQuality: 0.2) else {
            print("😡 ERROR: Could not resize image")
            return false
        }
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg" // Setting metadata allows you to see console image in the web browser. This seteting will work for png as well as jpeg
        var imageURLString = "" // We'll set this after the image is successfully saved
        
        do {
            let _ = try await storageRef.putDataAsync(resizedImage, metadata: metadata)
            print("📸 Image Saved!")
            do {
                let imageURL = try await storageRef.downloadURL()
                imageURLString = "\(imageURL)" // We'll save this to Cloud Firestore as part of document in 'photos' collection, below
            } catch {
                print("😡 ERROR: Could not get imageURL after saving image \(error.localizedDescription)")
                return false
            }
        } catch {
            print("😡 ERROR: uploading image to FirebaseStorage")
            return false
        }
        
        // Now save to the "photos" collection of the spot document "spotID"
        let db = Firestore.firestore()
        let collectionString = "flowItem/\(flowID)/photos"
        
        do {
            var newPhoto = photo
            newPhoto.imageURLString = imageURLString
            try await db.collection(collectionString).document(photoName).setData(newPhoto.dictionary)
            print("😎 Data updated successfully!")
            return true
        } catch {
            print("😡 ERROR: Could not update data in 'photos' for flowID \(flowID)")
            return false
        }
    }
    
}

import FirebaseFirestoreSwift
struct ProjModel: Identifiable, Codable {
    @DocumentID var id: String?
    var name: String = ""
    var title: String = ""
    var owner: String = Auth.auth().currentUser?.uid ?? ""
    //    var postedOn: Date = Date()
    
    var dictionary:  [String: Any] {
        return ["name": name, "title": title, "owner": owner, "postedOn": Timestamp(date: Date.now)]
    }
}
