//
//  DetailAppView.swift
//  oz2
//
//  Created by özgün aksoy on 2023-07-28.
//

import SwiftUI

struct DetailAppView: View {
    let project: ProjectModel = ProjectModel(name: "Sample", description: "Sample project I have been working on for some time.")

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
                    
                }
                .font(.title)
                
                Section("Tech I Work With") {
                    
                }
                .font(.title)
                
            }
        }
    }
}



struct DetailAppView_Previews: PreviewProvider {
    static var previews: some View {
        DetailAppView()
    }
}

