//
//  SkillsView.swift
//  oz2
//
//  Created by özgün aksoy on 2023-07-29.
//

import SwiftUI

struct SkillsView: View {
    @State var skillList: [SkillModel] = [SkillModel(id: 0, name: "Swift", degree: 5, yearsOfExperience: 2),
                                          SkillModel(id: 1, name: "SwiftUI", degree: 5, yearsOfExperience: 2),
                                          SkillModel(id: 2, name: "UIKit", degree: 5, yearsOfExperience: 2),
                                          SkillModel(id: 3, name: "Flutter", degree: 3, yearsOfExperience: 1),
                                          SkillModel(id: 4, name: "Firebase", degree: 3, yearsOfExperience: 1),
                                          SkillModel(id: 5, name: "UI/UX", degree: 5, yearsOfExperience: 1),
                                          SkillModel(id: 6, name: "GIT", degree: 4, yearsOfExperience: 1),
                                          SkillModel(id: 7, name: "Network", degree: 4, yearsOfExperience: 1)]
    var body: some View {
        VStack (alignment: .leading) {
            Text("SKILLS")
                .font(.title2)
                .padding(.bottom, 4)
            
            ForEach(skillList) { skill in
                HStack {
                    Text(skill.name)
                        .font(.body)
                    Spacer()
                    ForEach(0 ..< 5) { item in
                        Image(systemName: skill.degree <= item ? "star" : "star.fill")
                        
                        
                    }
                }
            }
            
        }
        .padding()
        .background(.thinMaterial)
        .cornerRadius(20)
        .shadow(radius: 2)
    }
}

struct SkillModel: Identifiable {
    var id: Int
    let name: String
    let degree: Int
    let yearsOfExperience: Int
}

struct SkillsView_Previews: PreviewProvider {
    static var previews: some View {
        SkillsView()
    }
}
