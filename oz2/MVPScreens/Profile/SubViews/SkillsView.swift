//
//  SkillsView.swift
//  oz2
//
//  Created by özgün aksoy on 2023-07-29.
//

import SwiftUI

class SkillsViewModel: ObservableObject {
    
    @Published var skillModel: SkillModel? = nil
    
}

struct SkillsView: View {
    
    @StateObject var vm = SkillsViewModel()
    @State var skillList: [SkillModel] = [SkillModel(name: "Swift", degree: 5, yearsOfExperience: 2),
                                          SkillModel(name: "SwiftUI", degree: 5, yearsOfExperience: 2),
                                          SkillModel(name: "UIKit", degree: 5, yearsOfExperience: 2),
                                          SkillModel(name: "Flutter", degree: 3, yearsOfExperience: 1),
                                          SkillModel(name: "Firebase", degree: 3, yearsOfExperience: 1),
                                          SkillModel(name: "UI/UX", degree: 5, yearsOfExperience: 1),
                                          SkillModel(name: "GIT", degree: 4, yearsOfExperience: 1),
                                          SkillModel(name: "Network", degree: 4, yearsOfExperience: 1)]
    @State private var isAddPressed: Bool = true

    
    
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
            
            Button {
                
            } label: {
                Image(systemName: "plus.circle")
                Text("Add Skill")
            }.padding()

        }
        .sheet(isPresented: $isAddPressed, content: {
            AddSkillView()
        })
        .padding()
        .background(.thinMaterial)
        .cornerRadius(20)
        .shadow(radius: 2)
    }
        
        
}

class AddSkillViewModel: ObservableObject {
    @Published var skillModel: SkillModel = SkillModel(name: "", degree: 5, yearsOfExperience: 1)
    
    func addSkill() {
    //  TODO: update firebase
    }
}

struct AddSkillView: View {
    
    @StateObject var vm = AddSkillViewModel()
    @State private var skillRate: Int = 5
    @State private var yearInt: Int = 1

    var body: some View {
        return VStack {
            Group {
                TextField("Skill Name", text: $vm.skillModel.name)
                    .textFieldStyle(.roundedBorder)
                
                Stepper(value: $vm.skillModel.degree, in: 1 ... 5) {
                    Text("Rate: \(vm.skillModel.degree)")
                }
                Stepper(value: $vm.skillModel.yearsOfExperience, in: 0 ... 25, step: 1) {
                    Text("Experience in years: \(vm.skillModel.yearsOfExperience)")
                }
            }
            Button("Add Skill") {
                vm.addSkill()
            }
            .padding()
            .buttonStyle(.borderedProminent)
            
        } .padding()

    }
}

struct SkillModel: Identifiable, Codable {
    var id: String = UUID().uuidString
    var name: String
    var degree: Int
    var yearsOfExperience: Int
}

struct SkillsView_Previews: PreviewProvider {
    static var previews: some View {
        SkillsView()
    }
}
