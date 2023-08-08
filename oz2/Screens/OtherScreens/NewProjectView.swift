//
//  NewProjectView.swift
//  oz2
//
//  Created by özgün aksoy on 2023-08-02.
//

import SwiftUI


struct NewProjectView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var selectedImages: [UIImage?] = [nil, nil, nil, nil, nil]
    @State private var showingImagePicker = false
    @State private var activeImageIndex: Int?
    @State private var projectName = ""
    @State private var projectDescription = ""
    @State private var longText = ""
    @State private var selectedTech = "Swift"

    let techOptions = ["Swift", "Kotlin", "React", "Python", "Java", "C#"]

    var body: some View {
        NavigationView {
            Form {
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
                    TextField("Project Name", text: $projectName)
                    TextField("Description", text: $projectDescription)
                }

                Section(header: Text("Long Text")) {
                    TextEditor(text: $longText)
                        .frame(height: 100)
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
            .navigationBarItems(
                trailing: Button("Save") {
                    // Handle the save action here
                    saveProject()
                }
            )
            .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
                ImagePicker(image: $selectedImages[activeImageIndex ?? 0])
            }
        }
    }

    func loadImage() {
        // You can add logic here if needed when an image is selected
    }

    func saveProject() {
        // Implement the logic to save the project
    }
}


struct NewProjectView_Previews: PreviewProvider {
    static var previews: some View {
        NewProjectView()
    }
}

