//
//  AddExperienceView.swift
//  oz2
//
//  Created by özgün aksoy on 2023-09-11.
//

import SwiftUI

class AddExperienceViewModel: ObservableObject {
    @Published var experienceModel: ExperienceModel = ExperienceModel(companyName: "", totalYear: 1, position: "", isStillWorking: false, details: "")
    @Published var experienceModels: [ExperienceModel] = []
    
    
    func addExperience() async throws {
        let user = try AuthenticationManager.shared.getAuthUser()
        try await FirestoreManager.shared.createUserExperience(userID: user.uid, experienceModel: experienceModel)
    }
    
    func getExperiences() async throws {
        let user = try AuthenticationManager.shared.getAuthUser()
        experienceModels = try await FirestoreManager.shared.getUserExperience(userID: user.uid)
    }
    
    func deleteExperiences(indexSet: IndexSet) {
        guard let user = try? AuthenticationManager.shared.getAuthUser() else { return }
        indexSet.map { experienceModels[$0] }.forEach { experience in
            guard let experienceID = experience.id else { return }
            FirestoreManager.shared.deleteExperience(userID: user.uid, experienceID: experienceID)
        }
    }
}

struct AddExperienceView: View {
    
    @StateObject var vm = AddExperienceViewModel()
    @State private var skillRate: Int = 5
    @State private var yearInt: Int = 1
    
    var body: some View {
        return VStack {
            List {
                ForEach(vm.experienceModels) { model in
                    Text(model.companyName)
                        .onTapGesture {
                        vm.experienceModel = model
                    }
                }
                .onDelete (perform: delete)
                
            }
            
            Group {
                TextField("Company Name", text: $vm.experienceModel.companyName)
                    .textFieldStyle(.roundedBorder)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .lineLimit(1)
                    .textFieldStyle(.plain)
                    .overlay {
                        RoundedRectangle(cornerRadius: 4)
                            .stroke(lineWidth: 1)
                    }
                    .background(.white)
                    .cornerRadius(4)
                    
                TextField("Position", text: $vm.experienceModel.position)
                    .textFieldStyle(.roundedBorder)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .lineLimit(1)
                    .textFieldStyle(.plain)
                    .overlay {
                        RoundedRectangle(cornerRadius: 4)
                            .stroke(lineWidth: 1)
                    }
                    .background(.white)
                    .cornerRadius(4)
                
                TextField("Details", text: $vm.experienceModel.details, axis: .vertical)
                    .textFieldStyle(.roundedBorder)
                    .textFieldStyle(.plain)
                    .overlay {
                        RoundedRectangle(cornerRadius: 4)
                            .stroke(lineWidth: 1)
                    }
                    .background(.white)
                    .cornerRadius(4)

                Stepper(value: $vm.experienceModel.totalYear, in: 0 ... 25) {
                    Text("Experience Year: \(vm.experienceModel.totalYear)")
                }
                
                Toggle("Still Working?", isOn: $vm.experienceModel.isStillWorking)
               
            }
            Button("Add Experience") {
                if !vm.experienceModel.companyName.isEmpty, !vm.experienceModel.position.isEmpty {
                    Task {
                        do {
                            try await vm.addExperience()
                            vm.experienceModel = ExperienceModel(companyName: "", totalYear: 1, position: "", isStillWorking: false, details: "")
                            try await vm.getExperiences()
                        } catch let error {
                            print("Error: adding experience \(error.localizedDescription)")
                        }
                    }
                    
                }
            }
            .padding()
            .buttonStyle(.borderedProminent)
            
        } .padding()
            .task {
                do {
                    try await vm.getExperiences()
                } catch let error {
                    print("Error: getting experiences \(error.localizedDescription)")
                }
                
            }
        
    }
    
    func delete(at indexSet: IndexSet)  {
        print(vm.experienceModels.first)
        vm.deleteExperiences(indexSet: indexSet)
    }
}

struct AddExperienceView_Previews: PreviewProvider {
    static var previews: some View {
        AddExperienceView()
    }
}
