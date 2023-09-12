//
//  AddSkillView.swift
//  oz2
//
//  Created by özgün aksoy on 2023-09-11.
//

import SwiftUI

class AddSkillViewModel: ObservableObject {
    @Published var skillModel: SkillModel = SkillModel(name: "", degree: 5, yearsOfExperience: 1)
    @Published var skillModels: [SkillModel] = []
    
    
    func addSkill() async throws {
        let user = try AuthenticationManager.shared.getAuthUser()
        try await FirestoreManager.shared.createUserSkill(userID: user.uid, skillModel: skillModel)
    }
    
    func getSkills() async throws {
        let user = try AuthenticationManager.shared.getAuthUser()
        skillModels = try await FirestoreManager.shared.getUserSkill(userID: user.uid)
    }
    
    func deleteSkills(indexSet: IndexSet) {
        guard let user = try? AuthenticationManager.shared.getAuthUser() else { return }
        indexSet.map { skillModels[$0] }.forEach { skill in
            guard let skillID = skill.id else { return }
            FirestoreManager.shared.deleteSkill(userID: user.uid, skillID: skillID)
        }
    }
}

struct AddSkillView: View {
    
    @StateObject var vm = AddSkillViewModel()
    @State private var skillRate: Int = 5
    @State private var yearInt: Int = 1
    
    var body: some View {
        return VStack {
            List {
                ForEach(vm.skillModels) { model in
                    Text(model.name)
                        .onTapGesture {
                        vm.skillModel = model
                    }
                }
                .onDelete (perform: delete)
                
            }
            
            Group {
                TextField("Skill Name", text: $vm.skillModel.name)
                    .textFieldStyle(.roundedBorder)
                    .textInputAutocapitalization(.never)
                    .lineLimit(1)
                    .textFieldStyle(.plain)
                    .overlay {
                        RoundedRectangle(cornerRadius: 4)
                            .stroke(lineWidth: 1)
                    }
                    .background(.white)
                    .cornerRadius(4)
                    
                
                Stepper(value: $vm.skillModel.degree, in: 1 ... 5) {
                    Text("Rate: \(vm.skillModel.degree)")
                }
                Stepper(value: $vm.skillModel.yearsOfExperience, in: 0 ... 25, step: 1) {
                    Text("Experience in years: \(vm.skillModel.yearsOfExperience)")
                }
            }
            Button("Add Skill") {
                if !vm.skillModel.name.isEmpty {
                    Task {
                        do {
                            try await vm.addSkill()
                            vm.skillModel = SkillModel(name: "", degree: 5, yearsOfExperience: 1)
                            try await vm.getSkills()
                        } catch let error {
                            print("Error: adding skill \(error.localizedDescription)")
                        }
                    }
                    
                }
            }
            .padding()
            .buttonStyle(.borderedProminent)
            
        } .padding()
            .task {
                do {
                    try await vm.getSkills()
                } catch let error {
                    print("Error: getting skills \(error.localizedDescription)")
                }
                
            }
        
    }
    
    func delete(at indexSet: IndexSet)  {
        print(vm.skillModels.first)
        vm.deleteSkills(indexSet: indexSet)
    }
}


struct AddSkillView_Previews: PreviewProvider {
    static var previews: some View {
        AddSkillView()
    }
}
