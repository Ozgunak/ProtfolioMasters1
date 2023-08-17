//
//  NewProjectView.swift
//  oz2
//
//  Created by özgün aksoy on 2023-08-02.
//

import SwiftUI
//import PhotosUI
import FirebaseFirestoreSwift

struct NewProjectView: View {
    @Environment(\.dismiss) private var dismiss
//    @FirestoreQuery(collectionPath: "flowIte") var photos: [ProjectPhotos] // Path changes on appear.
    @StateObject var newProjectVM = NewProjectViewModel()

    @State private var selectedImages: [UIImage?] = [nil, nil, nil, nil, nil]
    @State private var showingImagePicker = false
    @State private var activeImageIndex: Int?
    @State private var selectedTech = "Swift"
    @State var profile: FlowModel
    @State var project: ProjectModel
    @State private var isLoading: Bool = false
    
    
    

    let techOptions = ["Swift", "Kotlin", "React", "Python", "Java", "C#"]
    
    var body: some View {
        ZStack {
            Form {
                if !project.imageNames.isEmpty {
                    Section(header: Text("Uploaded Images")) {
    //                    HStack {
    //                        ForEach(project.imageNames, id: \.self) { url in
    //                            AsyncImage(url: URL(string: url)) { image in
    //                                image
    //                                    .resizable()
    //                                    .scaledToFit()
    //                            } placeholder: {
    //                                ProgressView()
    //                            }
    //
    //                        }
    //                    }
                        CarouselDetailView(imageNames: project.imageNames)
                    }
                }
                Section(header: Text("Select Images")) {
                    HStack {
                        ForEach(0..<5) { index in
                            Image(uiImage: selectedImages[index] ?? UIImage(systemName: "photo")!)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 60, height: 60)
                                .onTapGesture {
                                    activeImageIndex = index
                                    showingImagePicker = true
                                }
                        }
                    }
                }
                
                Section(header: Text("Project Details")) {
                    TextField("Project Name", text: $project.name)
                    TextField("Description", text: $project.description, axis: .vertical)
                }
                
                Section(header: Text("Details")) {
                    TextEditor(text: $project.detail)
                        .frame(maxHeight: .infinity)
                }
                
                Section(header: Text("Technologies")) {
                    Picker("Select Technology", selection: $selectedTech) {
                        ForEach(techOptions, id: \.self) { tech in
                            Text(tech)
                        }
                    }
                }
            }
            .navigationBarTitle("Create New Project", displayMode: .inline)
            .navigationBarBackButtonHidden()
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveProject()
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            })
            // MARK: sheet
            .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
                ImagePicker(image: $selectedImages[activeImageIndex ?? 0])
            }
            // MARK: on appear
            .onAppear {
    //            if profile.id != nil, project.id != nil {
    //                $photos.path = "flowItem/\(profile.id ?? "")/projects/\(project.id ?? "")/photos"
    //                print("photos.path \($photos.path)")
    //            }
            }
            if isLoading {
                ProgressView()
            }
        }
    }

    func loadImage() {
        // You can add logic here if needed when an image is selected
    }

    func saveProject() {
        isLoading.toggle()
        Task {
            let result = await newProjectVM.saveProjectWithImage(profile: profile, project:project, projectPhotos: ProjectPhotos(), images: selectedImages)
            if result {
                isLoading.toggle()
                dismiss()
            } else {
                isLoading.toggle()
                // TODO: show alert
            }
        }
    }
}


struct NewProjectView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            NewProjectView(profile: FlowModel(), project: ProjectModel())
        }
    }
}

import Firebase
struct ProjectPhotos: Codable, Identifiable, Hashable {
    @DocumentID var id: String?
    var photoList: [String] = []
    var publishTime = Date()
    
    var dictionary: [String: Any] {
        return ["photoList": photoList, "publishTime": Timestamp(date: Date())]
    }
}

