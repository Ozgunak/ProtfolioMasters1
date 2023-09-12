//
//  ExpreienceView.swift
//  oz2
//
//  Created by özgün aksoy on 2023-07-29.
//

import SwiftUI

class ExperienceViewModel: ObservableObject {
    
    @Published var experienceModel: ExperienceModel? = nil
    @Published var experienceList: [ExperienceModel] = []
    
    func getExperiences() async throws {
        let user = try AuthenticationManager.shared.getAuthUser()
        experienceList = try await FirestoreManager.shared.getUserExperience(userID: user.uid)
    }
    
}

struct ExperienceView: View {
    
    @StateObject var vm = ExperienceViewModel()
    @State private var isAddPressed: Bool = false
    @State private var isLoading: Bool = false
    @Binding var isOwner: Bool
    
    
    var body: some View {
        VStack {
            if isLoading {
                ProgressView()
            } else {
                VStack (alignment: .leading) {
                    Text("Experiences")
                        .font(.title2)
                        .padding(.bottom, 4)
                    
                    ForEach(vm.experienceList) { experience in
                        VStack(alignment: .leading) {
                            HStack {
                                Text(experience.companyName)
                                    .font(.title3)
                                Text(experience.isStillWorking ? "Currently Working" : "")
                                    .font(.caption)
                                    .foregroundColor(.accentColor)
                                Spacer()
                                
                                Text("(\(experience.totalYear) years)")
                                    .font(.caption)
                                
                                Text(experience.position)
                                    .font(.body)

                                
    // isStillWorking
                            }
                            Text(experience.details)
                                .font(.caption)
                        }
                        .padding(4)
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
                        try await vm.getExperiences()
                    }
                }, content: {
                    AddExperienceView()

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
                try await vm.getExperiences()
                isLoading = false
            }
        }
    }
    
    
}

import FirebaseFirestoreSwift

struct ExperienceModel: Identifiable, Codable {
    @DocumentID var id: String?
    var companyName: String
    var totalYear: Int
    var position: String
    var isStillWorking: Bool
    var details: String
    
    var dictionary: [String: Any] {
        return ["companyName": companyName, "position": position, "totalYear": totalYear, "isStillWorking": isStillWorking, "details": details]
    }
}
struct ExperienceView_Previews: PreviewProvider {
    static var previews: some View {
        ExperienceView(isOwner: .constant(true))
    }
}
