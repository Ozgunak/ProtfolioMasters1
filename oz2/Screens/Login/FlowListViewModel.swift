//
//  FlowListViewModel.swift
//  oz2
//
//  Created by özgün aksoy on 2023-08-09.
//

import Foundation
import FirebaseFirestoreSwift
import FirebaseFirestore

class FlowListViewModel: ObservableObject {
    @Published var flowItems: [FlowModel] = []
    
//    func loadFlowItems() async -> [FlowModel] {
//        let db = Firestore.firestore()
//        print("load starts")
//
//        do {
//            var flowList: [FlowModel] = []
//            let snapshots = try? await db.collection("flowItem").getDocuments()
////            if let snapshots as FlowModel {
////                ForEach(snapshots) { snapshot in
////                    flowList.append(snapshot)
////                }
////            }
//        } catch {
//            print("Error: could not load data \(error.localizedDescription)")
//        }
//    }
    

}
