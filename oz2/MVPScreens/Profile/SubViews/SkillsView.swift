//
//  SkillsView.swift
//  oz2
//
//  Created by özgün aksoy on 2023-07-29.
//

import SwiftUI

class SkillsViewModel: ObservableObject {
    
    @Published var skillModel: SkillModel? = nil
    @Published var skillList: [SkillModel] = []
    
    func getSkills() async throws {
        let user = try AuthenticationManager.shared.getAuthUser()
        skillList = try await FirestoreManager.shared.getUserSkill(userID: user.uid)
    }
    
}

struct SkillsView: View {
    
    @StateObject var vm = SkillsViewModel()
    @State private var isAddPressed: Bool = false
    @State private var isLoading: Bool = false
    @Binding var isOwner: Bool
    
    
    var body: some View {
        VStack {
            if isLoading {
                ProgressView()
            } else {
                VStack (alignment: .leading) {
                    Text("SKILLS")
                        .font(.title2)
                        .padding(.bottom, 4)
                    
                    ForEach(vm.skillList) { skill in
                        HStack(alignment: .lastTextBaseline) {
                            Text(skill.name)
                                .font(.body)
                                .padding(.bottom, 4)
                                .lineLimit(1)
                                .minimumScaleFactor(0.7)
                            Spacer()
                            Text("\(skill.yearsOfExperience) years")
                                .font(.caption)
                                .padding(.bottom, 4)
                            ForEach(0 ..< 5) { item in
                                Image(systemName: skill.degree <= item ? "star" : "star.fill")
                                
                                
                            }
                        }
                    }
                    if isOwner {
                        Button {
                            isAddPressed.toggle()
                        } label: {
                            Image(systemName: "plus.circle")
                            Text("Add or Edit Skill")
                        }.padding()
                    }
                    
                }
                
                .sheet(isPresented: $isAddPressed, onDismiss: {
                    Task {
                        try await vm.getSkills()
                    }
                }, content: {
                    AddSkillView()

                })
                .padding()
                .background(.thinMaterial)
                .cornerRadius(20)
                .shadow(radius: 2)
            }
        }
        .onAppear {
            isLoading = true
            Task {
                try await vm.getSkills()
                isLoading = false
            }
        }
    }
    
    
}

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

import FirebaseFirestoreSwift

struct SkillModel: Identifiable, Codable {
    @DocumentID var id: String?
    var name: String
    var degree: Int
    var yearsOfExperience: Int
    
    var dictionary:  [String: Any] {
        return ["name": name, "degree": degree, "yearsOfExperience": yearsOfExperience]
    }
}

struct SkillsView_Previews: PreviewProvider {
    static var previews: some View {
        SkillsView(isOwner: .constant(true))
    }
}
