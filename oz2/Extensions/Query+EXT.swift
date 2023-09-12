//
//  Query+EXT.swift
//  oz2
//
//  Created by özgün aksoy on 2023-09-11.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

extension Query {
    
    func getDocuments<T>(as type: T.Type) async throws -> [T] where T : Decodable {
        try await getDocumentsWithSnapshot(as: type).items
    }
    
    func getDocumentsWithSnapshot<T>(as type: T.Type) async throws -> (items: [T], lastDocument: DocumentSnapshot?) where T : Decodable {
        let snapshot = try await self.getDocuments()
        
        let items = try snapshot.documents.map({ document in
            try document.data(as: T.self)
        })
        
        return (items, snapshot.documents.last)
    }
    
}
