//
//  ProjectDetailView.swift
//  oz2
//
//  Created by özgün aksoy on 2023-08-15.
//

import SwiftUI

struct ProjectDetailView: View {
    @State var project: FlowItemModel
    

    var body: some View {
        VStack {
            FlowHeaderView(name: project.name, title: project.name, country: "CA", profileImage: project.progileImage)
            CarouselDetailView(imageNames: project.imageNames, imageHeight: 450)
            Text("Image Name")
            Text("Image Name")

            Spacer()
        }
    }
}

struct ProjectDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectDetailView(project: FlowItemModel(id: "Ynxp7VNRNnNp9ujwbDj5", name: "Zey", title: "Data", projectName: "3", description: "", detail: "", profileID: "2HO0eRaDNgzdfR2YUva7", progileImage: "https://firebasestorage.googleapis.com:443/v0/b/portfoliomasters1.appspot.com/o/2HO0eRaDNgzdfR2YUva7%2FD9DF52FF-B59F-4622-9A0F-EABB6927DA6E.jpeg?alt=media&token=1da7a546-b9b5-49eb-a62b-a72935f27e8b", imageNames: ["https://firebasestorage.googleapis.com:443/v0/b/portfoliomasters1.appspot.com/o/2HO0eRaDNgzdfR2YUva7%2FjetiO8TXGiavZODaRj56%2F40BC9B63-2F4B-43C0-9FAE-86202C05631C.jpeg?alt=media&token=b9f39831-eec9-4bae-8e5d-edb4a5b117f3", "https://firebasestorage.googleapis.com:443/v0/b/portfoliomasters1.appspot.com/o/2HO0eRaDNgzdfR2YUva7%2FjetiO8TXGiavZODaRj56%2FE9680CBD-F453-4AA2-B005-6829952FCA54.jpeg?alt=media&token=e669b38a-3fbb-406f-9f54-e29a28438f9f", "https://firebasestorage.googleapis.com:443/v0/b/portfoliomasters1.appspot.com/o/2HO0eRaDNgzdfR2YUva7%2FjetiO8TXGiavZODaRj56%2FF20A9651-B92E-4E35-92B3-6B82E8909879.jpeg?alt=media&token=a21977f0-ee75-420d-8471-38e4579075c2"], owner: "1@2.com"))
    }
}
