//
//  FlowListView.swift
//  oz2
//
//  Created by özgün aksoy on 2023-08-09.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift

struct FlowListView: View {
    @FirestoreQuery(collectionPath: "flowItem", animation: .easeIn) var flowItems: [FlowModel]
    @Environment(\.dismiss) private var dismiss
    @State private var flows: [FlowModel] = []
    @State private var isNewListPresented: Bool = false
    

    var body: some View {
        NavigationStack {
            List {
                ForEach(flowItems) { item in
                    NavigationLink(destination: {
                        FlowDetailView(flow: item)
                    }, label: {
                        FlowHeaderView(name: item.name, title: item.title, country: "Ca")
                    })
                    
                }
            }
            .listStyle(.plain)
            .navigationTitle("Users")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Log Out") {
                        do {
                            try Auth.auth().signOut()
                            dismiss()
                        } catch {
                            print("😡 Error: sign out \(error.localizedDescription)")
                        }
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        isNewListPresented.toggle()
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $isNewListPresented) {
                NavigationStack {
                    FlowDetailView(flow: FlowModel())
                }
        }
        }
    }
}



struct FlowListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            FlowListView()
        }
    }
}
