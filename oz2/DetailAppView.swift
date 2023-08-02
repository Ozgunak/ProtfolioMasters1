//
//  DetailAppView.swift
//  oz2
//
//  Created by özgün aksoy on 2023-07-28.
//

import SwiftUI

struct DetailAppView: View {
    let project: Project = Project(name: "Sample", description: "Sample project I have been working on for some time.", tech: ["SwiftUI", "Firebase", "Github", "CoreData"], developmentTime: "1 weeks")

    var body: some View {
        VStack {
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(content: {
                    ForEach(1...3, id: \.self) { count in
                        VStack {
                            Image("phoneScreen").resizable().aspectRatio(contentMode: .fit)
                        }
                    }
                })
            }
            .frame(height: 400)
                
            Text(project.name).font(.largeTitle)
            Text(project.description).font(.caption)
            List {
                Section("What I learned") {
                    ForEach(project.tech, id: \.self) { tech in
                        Text(tech).font(.title3)
                    }
                }
                .font(.title)
                
                Section("Tech I Work With") {
                    ForEach(project.tech, id: \.self) { tech in
                        Text(tech).font(.title3)
                    }
                }
                .font(.title)
                
            }
        }
    }
}

struct Project : Hashable, Identifiable, Codable {
    var id = UUID().uuidString
    var name: String
    var description: String
    var tech: [String]
    var developmentTime: String?
    var imageNames: [String]?
    var detail: String?
    
}


struct DetailAppView_Previews: PreviewProvider {
    static var previews: some View {
        DetailAppView()
    }
}

