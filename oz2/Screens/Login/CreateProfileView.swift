//
//  CreateProfileView.swift
//  oz2
//
//  Created by özgün aksoy on 2023-08-09.
//

import SwiftUI
import PhotosUI
import FirebaseFirestoreSwift

struct CreateProfileView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject var flowItemVM = FlowDetailViewModel()
    @State private var isAlertPresented: Bool = false
    @State var flow: FlowModel
    @State private var isButtonDisable: Bool = true
    
    @State private var newImage: UIImage?
    @State private var selectedPhoto: PhotosPickerItem?
    
    @FirestoreQuery(collectionPath: "flowIte") var projectsModel: [ProjectModel] // Path changes on appear.
    @FirestoreQuery(collectionPath: "flowIte") var photos: [Photo] // Path changes on appear.
    
    var previewRunning = false
    
    
    var body: some View {
        
        //        ScrollView {
        VStack {
            HStack(alignment: .bottom) {
                
                if flow.profileImage != "" {
                    AsyncImage(url: URL(string: flow.profileImage)) { image in
                        image.resizable()
                            .scaledToFill()
                            .frame(width: 150, height: 150)
                            .clipShape(Circle())
                    } placeholder: {
                        ProgressView()
                            .frame(width: 150, height: 150)
                    }
                } else {
                    PhotosPicker(selection: $selectedPhoto, matching: .images, preferredItemEncoding: .automatic) {
                        if let newImage {
                            Image(uiImage: newImage)
                                .resizable()
                                .scaledToFill()
                                .font(.title)
                                .frame(width: 150, height: 150)
                                .clipShape(Circle())
                        } else {
                            Image(systemName: "photo")
                                .resizable()
                                .scaledToFit()
                                .font(.title)
                                .frame(width: 150, height: 150)
                            
                        }
                    }
                    .onChange(of: selectedPhoto) { newValue in
                        Task {
                            do {
                                if let data = try await newValue?.loadTransferable(type: Data.self) {
                                    if let uiImage = UIImage(data: data) {
                                        newImage = uiImage
                                        print("📷 Succesfully selected Image")
                                    }
                                }
                            } catch {
                                print("😡 Error: selected image failed \(error.localizedDescription)")
                            }
                        }
                    }
                }
                
                VStack {
                    Group {
                        TextField("Name", text: $flow.name)
                            .textFieldStyle(.roundedBorder)
    //                        .padding()
                            .font(.title2)
                            .autocorrectionDisabled()
                            .onChange(of: flow.name, perform: { _ in
                                isTextValid()
                            })
                        
                        TextField("Title", text: $flow.title)
                            .textFieldStyle(.roundedBorder)
    //                        .padding()
                            .font(.title2)
                            .padding(.bottom, 50)
                            .autocorrectionDisabled()
                            .onChange(of: flow.title, perform: { _ in
                                isTextValid()
                            })
                    }
                    .disabled(flow.id == nil ? false : true)
                }
            }
            .padding(.horizontal)
            
            
            CarouselDetailView(imageNames: [])
            
            
            
            //            if flow.id == nil {
            // MARK: Save Button
            Button {
                if isTextValid() {
                    Task {
                        if let newImage {
                            let isUploadedPhoto = await flowItemVM.saveFlowItemWithImage(item: flow, image: newImage)
                            if isUploadedPhoto {
                                dismiss()
                            } else {
                                isAlertPresented.toggle()
                            }
                        } else {
                            let success = await flowItemVM.saveFlowItem(item: flow)
                            if success {
                                flow.title = ""
                                flow.name = ""
                                //                                dismiss()
                            } else {
                                isAlertPresented.toggle()
                            }
                        }
                    }
                }
            } label: {
                Text("Save")
            }
            .buttonStyle(.borderedProminent)
            .tint(.black)
            //            }
            
            // MARK: Projects
            HStack {
                Text("Projects").font(.title2)
                Spacer()
                NavigationLink {
                    //                    ProjDetailView(flow: flow, project: ProjModel())
                    NewProjectView(project: ProjectModel())
                } label: {
                    Text("Add Projects")
                    
                }
                
                
            }
            .padding(.horizontal)
            
            List {
                ForEach(projectsModel) { project in
                    NavigationLink {
                        NewProjectView(project: project)
                    } label: {
                        VStack(alignment: .leading) {
                            Text(String(project.name))
                                .font(.title2)
                            Text(String(project.description))
                            CarouselDetailView(imageNames: project.imageNames)
                        }
                    }
                }
            }
            .listStyle(.plain)
            
        }
        // MARK: Alert
        .alert(isPresented: $isAlertPresented) {
            Alert(title: Text("Something went wrong!!"), dismissButton: .cancel())
        }
        // MARK: On Appear
        .onAppear {
            if let profileID = flow.id { //!previewRunning && flow.id != ""?
                $projectsModel.path = "flowItem/\(profileID)/projects"
                print("projects.path \($projectsModel.path)")
                
                $photos.path = "flowItem/\(profileID)/photos"
                print("photos.path \($photos.path)")
            }
        }
        .navigationTitle(flow.id == nil ? "Create New Profile" : flow.name)
        .navigationBarTitleDisplayMode(.inline)
        //        }
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

struct CreateProfileView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            CreateProfileView(flow: FlowModel(), previewRunning: true)
        }
    }
}

struct PhotoView: View {
    @State var photos: [Photo]
    
    var body: some View {
        ScrollView(.horizontal) {
            ForEach(photos) { photo in
                //                                        Task {
                AsyncImage(url: URL(string: photo.imageURLString)) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                } placeholder: {
                    ProgressView()
                        .frame(width: 200, height: 200)
                }
                
                //                                        }
            }
        }
    }
    
    
}
