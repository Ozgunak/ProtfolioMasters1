//
//  ProjDetailViewModel.swift
//  oz2
//
//  Created by özgün aksoy on 2023-08-10.
//

import Foundation
import FirebaseFirestore
import Firebase

class ProjDetailViewModel: ObservableObject {
    @Published var project = ProjModel()
    
    func saveProj(item: FlowModel, project: ProjModel) async -> Bool {
        let db = Firestore.firestore()
        print("Proj save starts")
        guard let flowID = item.id else {
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
}

import FirebaseFirestoreSwift
struct ProjModel: Identifiable, Codable {
    @DocumentID var id: String?
    var name: String = ""
    var title: String = ""
    var owner: String = Auth.auth().currentUser?.email ?? ""
//    var postedOn: Date = Date()
    
    var dictionary:  [String: Any] {
        return ["name": name, "title": title, "owner": owner, "postedOn": Timestamp(date: Date.now)]
    }
}
