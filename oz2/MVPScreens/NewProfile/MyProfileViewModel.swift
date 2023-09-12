//
//  NewProfileViewModel.swift
//  oz2
//
//  Created by özgün aksoy on 2023-08-07.
//

import Foundation
import UIKit

@MainActor
class MyProfileViewModel: ObservableObject {
    @Published var myProfile: UserProfileModel = UserProfileModel(name: "", title: "")
    @Published var user: DBUser?
    
    init() {
        loadProfile()
    }
    
    func getProfile() async throws {
        let authResult = try AuthenticationManager.shared.getAuthUser()
        self.user = try await FirestoreManager.shared.getUser(userID: authResult.uid)
        myProfile = UserProfileModel(id: user?.userId,
                                     name: user?.name ?? "",
                                     title: user?.title ?? "",
                                     aboutMe: user?.aboutMe ?? "",
                                     country: user?.country ?? "",
                                     profileImageUrl: user?.profileImageUrl ?? "",
                                     projects: nil,
                                     githubURL: user?.githubURL ?? "",
                                     linkedInURL: user?.linkedInURL ?? "",
                                     twitterURL: user?.twitterURL ?? "",
                                     facebookURL: user?.facebookURL ?? "",
                                     instagramURL: user?.instagramURL ?? "",
                                     personalWebsiteURL: user?.personalWebsiteURL ?? "")
        
        // TODO: continue
        
    }
    
    
    func saveImage(image: UIImage) async throws {
        guard let user else { return }
        
        LocalFileManager.instance.saveImage(image: image, imageName: user.userId, folderName: "profileImage")
        
        Task {
            guard let data = image.jpegData(compressionQuality: 0.5) else {
                throw URLError(.backgroundSessionWasDisconnected)
            }
            let (path, name) = try await StorageManager.shared.saveImage(data: data, userId: user.userId)
            print("SUCCESS!")
            print(path)
            print(name)
            let url = try await StorageManager.shared.getUrlForImage(path: path)
            try await FirestoreManager.shared.updateUserProfileImagePath(userId: user.userId, path: path, url: url.absoluteString)
        }
        
    }
    
    // MARK: Save to documents
    
    func createNewProfile() async throws {
        // save to cloud
        let authResult = try AuthenticationManager.shared.getAuthUser()
        //         TODO: upload profile image
        
        try await FirestoreManager.shared.updateUser(userID: authResult.uid, profileModel: myProfile)
        
        
        
        // save to coredata
        //        myProfile = newProfile
        let path = URL.documentsDirectory.appending(component: "myProfile")
        let data = try? JSONEncoder().encode(myProfile)
        do {
            try data?.write(to: path)
        } catch {
            print("ERROR: Could not save data \(error.localizedDescription)")
        }
        
        // update auth user profile
    }
    
    func saveProfile() {
        let path = URL.documentsDirectory.appending(component: "myProfile")
        let data = try? JSONEncoder().encode(myProfile)
        do {
            try data?.write(to: path)
        } catch {
            print("ERROR: Could not save data \(error.localizedDescription)")
        }
    }
    
    func loadProfile() {
        let path = URL.documentsDirectory.appending(component: "myProfile")
        guard let data = try? Data(contentsOf: path) else {return}
        do {
            myProfile = try JSONDecoder().decode(UserProfileModel.self, from: data)
        } catch {
            print("ERROR: Could not load data \(error.localizedDescription)")
        }
    }
    
    func updateProfile(profile: UserProfileModel) {
        // save to coredata
        // save to cloud
    }
    
    func deleteProfile(profile: UserProfileModel) {
        // delete from coredata
        // delete from cloud
    }
}

var testProfile: UserProfileModel = UserProfileModel(id: UUID().uuidString, name: "Ozgun Aksoy T", title: "iOS Dev T", aboutMe: "2 Years of experiened, Masters Degree in Software Development", country: "Ca", profileImageUrl: "", projects: testProjects, githubURL: "github", linkedInURL: "linkedin", twitterURL: "X", facebookURL: "face", instagramURL: "insta", personalWebsiteURL: "ozgunaksoy.com")

var testProfiles: [UserProfileModel] = [UserProfileModel(name: "Oz Aksoy", title: "iOS Developer", country: "CA", projects: testProjects), UserProfileModel(name: "Zey Aksoy", title: "iOS Developer", country: "CA", projects: testProjects)]


var testProjects:[ProjectModel] = [
    ProjectModel(name: "AR&EZ", description: "I've designed and developed an application called \"AR&EZ\" to increase the usability of local stores with the mobile application.", imageNames: ["arez1","arez2","arez3","arez4","arez5"]),
    ProjectModel(name: "To Do App", description:
                """
            Todo App is a final project for Mobven Bootcamp. \n This project is created with VIP clean architecture pattern. \nCreate, Read, Update and Delete (CRUD) with CoreData \nLocal notifications can be set \nTodos should be created with title. Descriptions and notifications are optional. \nNotification gets deleted if todo deleted or marked as done.
            As default todos sorted by creation time. Sorting by last or first modification date can be done with sort button. \nUser can search by title
            """, imageNames: ["todo1", "todo2", "todo3", "todo4", "todo5",]),
    ProjectModel(name: "Grocery", description: """
Grocery Shop app lets you buy items with a few taps.
You can add item to your cart.
You can check categories and add different items to cart togerher.
Increasing, decreasing and deleting item from cart is possible.
With this lovely app every order you make is a success.
Since this is learning project, a few details created randomly like prices and images.
"""
                 , imageNames: ["grocery1", "grocery2", "grocery3", "grocery4", "grocery5"]),
    //    ProjectModel(name: "Add Project", description: "", tech: [])
]

