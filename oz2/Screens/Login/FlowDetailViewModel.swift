//
//  FlowListItemViewModel.swift
//  oz2
//
//  Created by özgün aksoy on 2023-08-09.
//

import Foundation
import FirebaseStorage
import FirebaseFirestore

class FlowDetailViewModel: ObservableObject {
    @Published var flowItem = FlowModel()
    
    func saveFlowItem(item: FlowModel) async -> Bool {
        let db = Firestore.firestore()
        print("save starts")
        if let id = item.id {
            do {
                try await db.collection("flowItem").document(id).setData(item.dictionary)
                print("succesfully updated")
                return true
            } catch {
                print("😡 Error could not update data \(error.localizedDescription)")
                return false
            }
        } else {
            do {
                let docRef = try await db.collection("flowItem").addDocument(data: item.dictionary)
//                self.flowItem = item
//                self.flowItem.id = docRef.documentID
                print("succesfully added")
                return true
            } catch {
                print("😡 Error could not update data \(error.localizedDescription)")
                return false
            }
        }        
    }
    
    func saveFlowItemWithImage(item: FlowModel, image: UIImage) async -> Bool {
        let db = Firestore.firestore()
        print("Profile save starts")
        print("📸📸image \(image)")
        if let id = item.id {
            do {
                try await db.collection("flowItem").document(id).setData(item.dictionary)
                print("succesfully updated")
                return true
            } catch {
                print("😡 Error could not update data \(error.localizedDescription)")
                return false
            }
        } else {
            do {
                let docRef = try await db.collection("flowItem").addDocument(data: item.dictionary)
//                self.flowItem = item
//                self.flowItem.id = docRef.documentID
                print("succesfully added")
                let docID = docRef.documentID
                var photoName = UUID().uuidString // This will be the name of the image file
                // MARK: Save photo to storage
                let storage = Storage.storage() // Create a Firebase Storage instance
                let storageRef = storage.reference().child("\(docID)/\(photoName).jpeg")
                
                guard let resizedImage = image.jpegData(compressionQuality: 0.2) else {
                    print("😡 ERROR: Could not resize image")
                    return false
                }
                
                let metadata = StorageMetadata()
                metadata.contentType = "image/jpg" // Setting metadata allows you to see console image in the web browser. This seteting will work for png as well as jpeg
                var imageURLString = "" // We'll set this after the image is successfully saved
                
                do {
                    let _ = try await storageRef.putDataAsync(resizedImage, metadata: metadata)
                    print("📸 Profile Image Saved!")
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
                
                do {
                    var newProf = item
                    newProf.profileImage = imageURLString
                    try await db.collection("flowItem").document(docID).setData(newProf.dictionary)
                    // Update one field, creating the document if it does not exist.
    //                db.collection("cities").document("BJ").setData([ "capital": true ], merge: true)
                    print("😎 Profile Image updated successfully!")
                    return true
                } catch {
                    print("😡 ERROR: Could not update data in 'profileImage' for flowID \(docID)")
                    return false
                }
                
                return true
            } catch {
                print("😡 Error could not update data \(error.localizedDescription)")
                return false
            }
        }
    }
    
    func saveProfileImage(flow: FlowModel, photo: Photo, image: UIImage) async -> Bool {
            guard let flowID = flow.id else {
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
                try await db.collection("flowItem").document(flowID).setData(["profileImage": newPhoto.imageURLString], merge: true)
                // Update one field, creating the document if it does not exist.
//                db.collection("cities").document("BJ").setData([ "capital": true ], merge: true)
                print("😎 Profile Image updated successfully!")
                return true
            } catch {
                print("😡 ERROR: Could not update data in 'profileImage' for flowID \(flowID)")
                return false
            }
        }

    
    func saveImage(flow: FlowModel, photo: Photo, image: UIImage) async -> Bool {
            guard let flowID = flow.id else {
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
