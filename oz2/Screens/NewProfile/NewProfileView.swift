//
//  NewProfileView.swift
//  oz2
//
//  Created by özgün aksoy on 2023-08-02.
//

import SwiftUI

struct NewProfileView: View {
    @State private var profileImage: Image? = Image(systemName: "person.circle")
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var profileVM: MyProfileViewModel
    
//    @State var profile: UserProfileModel = UserProfileModel(name: "", title: "")
    
    let countries = ["United States", "Canada", "United Kingdom", "Germany", "France", "China", "Japan"]
    
    var body: some View {
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
                    TextField("Name", text: $profileVM.myProfile.name)
                    TextField("Title", text: $profileVM.myProfile.title)
                    
                    TextField("About Me", text: $profileVM.myProfile.aboutMe, axis: .vertical)
                    //                        TextField("About Me", text: $profile.aboutMe)
                }
                
                Section(header: Text("Location")) {
                    Picker("Country", selection: $profileVM.myProfile.country) {
                        ForEach(countries, id: \.self) { country in
                            Text(country)
                        }
                    }
                }
                
                Section(header: Text("Social Links")) {
                    TextField("GitHub URL", text: $profileVM.myProfile.githubURL)
                    TextField("LinkedIn URL", text: $profileVM.myProfile.linkedInURL)
                    TextField("Twitter URL", text: $profileVM.myProfile.twitterURL)
                    TextField("Facebook URL", text: $profileVM.myProfile.facebookURL)
                    TextField("Instagram URL", text: $profileVM.myProfile.instagramURL)
                    TextField("Personal Website", text: $profileVM.myProfile.personalWebsiteURL)
                }
            }
            .navigationBarTitle("Create Profile", displayMode: .inline)
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel", action: {
                        dismiss()
                    })
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save", action: {
                        self.saveProfile()
                        
                    }
                    )
                }
            })
        }
        .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
            ImagePicker(image: self.$inputImage)
        }
    }
    
    func saveProfile() {
        // Implement the logic to save the profile
        profileVM.createNewProfile(newProfile: UserProfileModel(id: UUID().uuidString,
                                                                name: profileVM.myProfile.name,
                                                                title: profileVM.myProfile.title,
                                                                aboutMe: profileVM.myProfile.aboutMe,
                                                                country: profileVM.myProfile.country))
        dismiss()
    }
    
    func loadImage() {
        guard let inputImage = inputImage else { return }
        profileImage = Image(uiImage: inputImage)
    }
}


struct ImagePicker: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    
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
        NavigationStack {
            NewProfileView()
                .environmentObject(MyProfileViewModel())
        }
    }
}

