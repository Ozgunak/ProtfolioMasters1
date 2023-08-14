//
//  projDetailView.swift
//  oz2
//
//  Created by özgün aksoy on 2023-08-10.
//

import SwiftUI
import Firebase

struct ProjDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject var projectVM = ProjDetailViewModel()
    @State private var isButtonDisable: Bool = true
    @State var flow: FlowModel
    @State var project: ProjModel
    @State var isThisUsersProject: Bool = false
    
    var body: some View {
        return VStack {
            
            Text("Add Project").font(.title).bold()
            Group {
            TextField("Project Name", text: $project.name)
                .textFieldStyle(.roundedBorder)
                .padding()
                .font(.title2)
                .autocorrectionDisabled()
                .onChange(of: project.name, perform: { _ in
                    isTextValid()
                })
            
            
                TextField("Project Desciption", text: $project.title, axis: .vertical)
                    .textFieldStyle(.roundedBorder)
                    .padding()
                    .font(.title2)
                    .padding(.bottom, 50)
                    .autocorrectionDisabled()
                    .onChange(of: project.title, perform: { _ in
                        isTextValid()
                })
            }
            .disabled(!isThisUsersProject)
            
            
            Button {
                if isTextValid() {
                    Task {
                        let success = await projectVM.saveProj(flow: flow, project: project)
                        if success {
                            flow.title = ""
                            flow.name = ""
                            dismiss()
                        } else {
                            print("")
                        }
                    }
                }
            } label: {
                Text("Save")
            }.buttonStyle(.borderedProminent)
                .tint(.black)
            if !isThisUsersProject {
                Spacer()
                Text("Created by:\(project.owner)")
            }
        }
        .onAppear {
            print(project.owner)
            print(Auth.auth().currentUser?.email)
            if project.owner == Auth.auth().currentUser?.email {
                isThisUsersProject = true
            }
        }
        
        func isTextValid() -> Bool {
            if (flow.title != "" && flow.name != "") {
                isButtonDisable = false
                return true
            } else {
                isButtonDisable = true
                return false
            }
            
        }
    }
    
}

struct ProjDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ProjDetailView(flow: FlowModel(), project: ProjModel())
    }
}
