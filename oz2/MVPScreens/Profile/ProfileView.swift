//
//  ProfileView.swift
//  oz2
//
//  Created by özgün aksoy on 2023-08-23.
//

import SwiftUI

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



struct ProfileView: View {
    @StateObject var viewModel = ProfileViewModel()
    @State private var isNewProfile: Bool = false

    var body: some View {
        HStack  {
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
            Spacer()
        }
        // MARK: Task
        .task {
            do {
                try await viewModel.getProfile()
                print("profile \(viewModel.userProfile)")
                self.isNewProfile = viewModel.userProfile == nil
            } catch {
                print("Error: getting profile \(error.localizedDescription)")
            }
            
        }
        // MARK: full screen cover
        .fullScreenCover(isPresented: $isNewProfile) {
            Task {
                do {
                    try await viewModel.getProfile()
                } catch {
                    print("Error: getting profile \(error.localizedDescription)")
                }
            }
        } content: {
            NavigationStack{
                NewProfileView()
            }
        }

    }
        
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
