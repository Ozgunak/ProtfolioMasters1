//
//  SkillsView.swift
//  oz2
//
//  Created by özgün aksoy on 2023-07-29.
//

import SwiftUI

@MainActor
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
                                    .foregroundColor(.accentColor)
                                
                                
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
