//
//  NewProfileView.swift
//  oz2
//
//  Created by özgün aksoy on 2023-08-02.
//

import SwiftUI

struct NewProfileView: View {
    @State private var name = ""
    @State private var title = ""
    @State private var aboutMe = ""
    @State private var country = "Canada"
    @State private var githubURL = ""
    @State private var linkedInURL = ""
    @State private var twitterURL = ""
    @State private var facebookURL = ""
    @State private var instagramURL = ""
    @State private var personalWebsiteURL = ""
    @State private var profileImage: Image? = Image(systemName: "person.circle")
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?

    @Environment(\.presentationMode) var presentationMode

    let countries = ["United States", "Canada", "United Kingdom", "Germany", "France", "China", "Japan"]

    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("Profile Photo")) {
                        HStack {
                            Spacer()
                            profileImage?
                                .resizable()
                                .scaledToFit()
                                .frame(height: 100)
                                .clipShape(Circle())
                                .onTapGesture {
                                    self.showingImagePicker = true
                                }
                            Spacer()
                        }
                    }
                    
                    Section(header: Text("Personal Information")) {
                        TextField("Name", text: $name)
                        TextField("Title", text: $title)
                        
//                        TextField("About Me", text: $aboutMe, axis: .vertical)
                        TextField("About Me", text: $aboutMe)
                    }
                    
                    Section(header: Text("Location")) {
                        Picker("Country", selection: $country) {
                            ForEach(countries, id: \.self) { country in
                                Text(country)
                            }
                        }
                    }
                    
                    Section(header: Text("Social Links")) {
                        TextField("GitHub URL", text: $githubURL)
                        TextField("LinkedIn URL", text: $linkedInURL)
                        TextField("Twitter URL", text: $twitterURL)
                        TextField("Facebook URL", text: $facebookURL)
                        TextField("Instagram URL", text: $instagramURL)
                        TextField("Personal Website", text: $personalWebsiteURL)
                    }
                }
                .navigationBarTitle("Create Profile", displayMode: .inline)
                .navigationBarItems(
                    leading: Button("Cancel") {
                        // Handle the cancel action here
                        self.presentationMode.wrappedValue.dismiss()
                    },
                    trailing: Button("Save") {
                        // Handle the save action here
                        self.saveProfile()
                    }
                )
            }
        }
        .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
            ImagePicker(image: self.$inputImage)
        }
    }
    func cancelProfileCreation() {
        // Implement the logic to cancel profile creation
        
    }
    
    func saveProfile() {
        // Implement the logic to save the profile
    }

    func loadImage() {
        guard let inputImage = inputImage else { return }
        profileImage = Image(uiImage: inputImage)
    }
}


struct ImagePicker: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.dismiss) private var dismiss

    @Binding var image: UIImage?

    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {

    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        var parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage
            }
//            dismiss()
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}



struct NewProfileView_Previews: PreviewProvider {
    static var previews: some View {
        NewProfileView()
    }
}

