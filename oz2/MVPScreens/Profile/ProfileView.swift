//
//  ProfileView.swift
//  oz2
//
//  Created by özgün aksoy on 2023-08-23.
//

import SwiftUI
import WebKit
import Firebase

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

struct ProfileView: View {
    @StateObject var viewModel = ProfileViewModel()
    @State private var isNewProfile: Bool = false
    @State private var aboutMeText: String = ""
    
    @State private var showWebView: Bool = false
    @State private var selectedURL: String? = nil
    
    
    var body: some View {
        ScrollView {
            VStack  {
                if !isNewProfile {
                    //                    FlowHeaderView(name: viewModel.userProfile?.name ?? "", title: viewModel.userProfile?.title ?? "", country: viewModel.userProfile?.country ?? "", profileImage: viewModel.userProfile?.profileImageUrl ?? "")
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
                    
                    
                    InfoView(aboutMeText: $aboutMeText, isOwner: .constant(viewModel.userProfile?.userId == Auth.auth().currentUser?.uid))
                    Spacer()
                    
                    if let url = viewModel.userProfile?.githubURL, !url.isEmpty {
                        let _ = print(url)
                        ProfileLinkButton(url: viewModel.userProfile?.githubURL, imageName: "github", text: "GitHub") {
                            selectedURL = url
                            showWebView = true
                        }
                    }
                    
                }
                //                ProfileLinkButton(url: viewModel.userProfile?.githubURL, imageName: "github", text: "GitHub")
                //                ProfileLinkButton(url: viewModel.userProfile?.linkedInURL, imageName: "linkedin", text: "LinkedIn")
                //                ProfileLinkButton(url: viewModel.userProfile?.personalWebsiteURL, imageName: "web", text: "Web Site")
                //                ProfileLinkButton(url: viewModel.userProfile?.facebookURL, imageName: "facebook", text: "Facebook")
                //                ProfileLinkButton(url: viewModel.userProfile?.twitterURL, imageName: "x", text: "X")
                //                ProfileLinkButton(url: viewModel.userProfile?.instagramURL, imageName: "instagram", text: "Instagram")
                
                //                linkButton(forURL: viewModel.userProfile?.githubURL, withImage: "github", andText: "GitHub")
                //                linkButton(forURL: viewModel.userProfile?.linkedInURL, withImage: "linkedin", andText: "LinkedIn")
                //                linkButton(forURL: viewModel.userProfile?.personalWebsiteURL, withImage: "web", andText: "Web Site")
                //                linkButton(forURL: viewModel.userProfile?.facebookURL, withImage: "facebook", andText: "Facebook")
                //                linkButton(forURL: viewModel.userProfile?.twitterURL, withImage: "x", andText: "X")
                //                linkButton(forURL: viewModel.userProfile?.instagramURL, withImage: "instagram", andText: "Instagram")
                
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
                        if let userMail = viewModel.userProfile?.email, !userMail.isEmpty {
                            self.isNewProfile = false
                        } else {
                            self.isNewProfile = true
                        }
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
            .sheet(isPresented: $showWebView) {
                if let url = selectedURL {
                    VStack {
                        HStack {
                            Button(action: {
                                showWebView = false
                            }) {
                                Text("Close")
                            }
                            .padding()
                            Spacer()
                        }
                        
                        WebView(urlString: url)
                        
                    }
                }
            }
            
            
        }
        
        
    }
}


struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ProfileView()
        }
    }
}


struct ProfileLinkButton: View {
    var url: String?
    var imageName: String
    var text: String
    var action: (() -> Void)? = nil
    
    var body: some View {
        Group {
            if let urlString = url, !urlString.isEmpty, let _ = URL(string: urlString) {
                Button(action: {
                    action?()
                }) {
                    HStack {
                        Image(imageName)
                            .resizable()
                            .frame(width: 24, height: 24)
                        Text(text)
                    }
                }
                .padding()
                .background(.thinMaterial)
                .clipShape(Capsule())
                .shadow(radius: 10)
            }
        }
    }
}


struct WebView: UIViewRepresentable {
    let urlString: String
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        //        webView.navigationDelegate = context.coordinator
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        //        if let url = URL(string: urlString) {
        let request = URLRequest(url: URL(string: urlString)!)
        uiView.load(request)
        //        }
    }
    
    //    func makeCoordinator() -> Coordinator {
    //        Coordinator(self)
    //    }
    //
    //    class Coordinator: NSObject, WKNavigationDelegate {
    //        var parent: WebView
    //
    //        init(_ parent: WebView) {
    //            self.parent = parent
    //        }
    //    }
}
