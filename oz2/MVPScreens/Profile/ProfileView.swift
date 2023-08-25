//
//  ProfileView.swift
//  oz2
//
//  Created by özgün aksoy on 2023-08-23.
//

import SwiftUI

@MainActor
final class ProfileViewModel: ObservableObject {
    @Published var userProfile: DBUser?
    
    func getProfile() async throws {
        let authResult = try AuthenticationManager.shared.getAuthUser()
        print("getting user for: \(authResult.uid)")
        self.userProfile = try await FirestoreManager.shared.getUser(userID: authResult.uid)
//
        // TODO: continue
        
    }

    
}

extension Binding {
    public func defaultValue<T>(_ value: T) -> Binding<T> where Value == Optional<T> {
        Binding<T> {
            wrappedValue ?? value
        } set: {
            wrappedValue = $0
        }
    }
}

struct ProfileView: View {
    @StateObject var viewModel = ProfileViewModel()
    @State private var isNewProfile: Bool = false
    @State private var aboutMeText: String = ""
    
    
    

    var body: some View {
        VStack  {
            if !isNewProfile {
//                FlowHeaderView(name: viewModel.userProfile?.name ?? "", title: viewModel.userProfile?.title ?? "", country: viewModel.userProfile?.country ?? "", profileImage: viewModel.userProfile?.profileImageUrl ?? "")
                HStack(alignment: .top) {
                    if !(viewModel.userProfile?.profileImageUrl?.isEmpty ?? true) {
                        AsyncImage(url: URL(string: viewModel.userProfile?.profileImageUrl ?? "")) { image in
                            image
                                .resizable()
                                .scaledToFill()
                            
                                .frame(width: 100, height: 100)
                            
                                .clipShape(Circle())
                                .overlay {
                                    Circle()
                                        .stroke(lineWidth: 2)
                                        .opacity(0.2)
                                }
                        } placeholder: {
                            ProgressView()
                                .frame(width: 100, height: 100)
                        }
                    } else {
                        Image(systemName: "person")
                            .resizable()
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                            .scaledToFill()
                            .overlay {
                                Circle()
                                    .stroke(lineWidth: 2)
                                    .opacity(0.2)
                            }
                    }
                    Spacer()
                    VStack(alignment: .trailing) {
                        Text(viewModel.userProfile?.name ?? "").font(.title).fontWeight(.semibold).lineLimit(1)
                        Text(viewModel.userProfile?.title ?? "").font(.headline)
                        Text(viewModel.userProfile?.country ?? "").font(.caption)
                    }
                    .lineLimit(1)
                }
                .padding()
            }
            InfoView(aboutMeText: $aboutMeText)
            Spacer()
            if let github = viewModel.userProfile?.githubURL, !github.isEmpty {
                Link(destination: URL(string: "https://github.com/ozgunak")!) {
                    Image("github")
                        .resizable()
                        .frame(width: 24, height: 24)
                    Text("GitHub")
                }
                .padding()
                .background(.thinMaterial)
                .clipShape(Capsule())
                .shadow(radius: 10)
            }
            if let linkedIn = viewModel.userProfile?.linkedInURL, !linkedIn.isEmpty {
                Link(destination: URL(string: "https://github.com/ozgunak")!) {
                    Image("linkedin")
                        .resizable()
                        .frame(width: 24, height: 24)
                    Text("LinkedIn")
                }
                .padding()
                .background(.thinMaterial)
                .clipShape(Capsule())
                .shadow(radius: 10)
            }
            if let web = viewModel.userProfile?.personalWebsiteURL, !web.isEmpty {
                Link(destination: URL(string: "https://github.com/ozgunak")!) {
                    Image(systemName: "globe")
                        .resizable()
                        .frame(width: 24, height: 24)
                    Text("Web Site")
                }
                .padding()
                .background(.thinMaterial)
                .clipShape(Capsule())
                .shadow(radius: 10)
            }
        }
        // MARK: Task
        .task {
            do {
                try await viewModel.getProfile()
                self.isNewProfile = viewModel.userProfile == nil
                self.aboutMeText = viewModel.userProfile?.aboutMe ?? ""
            } catch {
                print("Error: getting profile \(error.localizedDescription)")
            }
            
        }
        // MARK: full screen cover
        .fullScreenCover(isPresented: $isNewProfile) {
            Task {
                do {
                    try await viewModel.getProfile()
                    self.aboutMeText = viewModel.userProfile?.aboutMe ?? ""
                } catch {
                    print("Error: getting profile \(error.localizedDescription)")
                }
            }
        } content: {
            NavigationStack{
                NewProfileView()
            }
        }
        // MARK: toolbar
        .toolbar(content: {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Edit", action: {
                    isNewProfile.toggle()
                })
            }
        })

    }
        
}

func ??<T>(lhs: Binding<Optional<T>>, rhs: T) -> Binding<T> {
    Binding(
        get: { lhs.wrappedValue ?? rhs },
        set: { lhs.wrappedValue = $0 }
    )
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ProfileView()
        }
    }
}
