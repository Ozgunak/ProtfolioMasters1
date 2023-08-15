//
//  NewProfileViewModel.swift
//  oz2
//
//  Created by özgün aksoy on 2023-08-07.
//

import Foundation

class MyProfileViewModel: ObservableObject {
    @Published var myProfile: UserProfileModel = UserProfileModel(name: "", title: "")
    
    init() {
        loadProfile()
//        myProfile = UserProfileModel(name: "1", title: "1", country: "CA", projects: testProjects)
    }
    
    func createNewProfile(newProfile: UserProfileModel) {
        // save to coredata
        myProfile = newProfile
        let path = URL.documentsDirectory.appending(component: "myProfile")
        let data = try? JSONEncoder().encode(myProfile)
        do {
            try data?.write(to: path)
        } catch {
            print("ERROR: Could not save data \(error.localizedDescription)")
        }
        // save to cloud
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

