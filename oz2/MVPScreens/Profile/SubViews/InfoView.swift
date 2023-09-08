//
//  InfoView.swift
//  oz2
//
//  Created by özgün aksoy on 2023-07-29.
//

import SwiftUI

enum InfoTabs: String,Codable,CaseIterable {
    case bio = "About Me"
    case skills = "Skills"
    case experience = "Experience"
    case apps = "Apps"
}


struct InfoView: View {
    @State var infoTabs: InfoTabs = .bio
    @Binding var aboutMeText: String
    
    var body: some View {
        VStack (alignment: .center, spacing: 12) {
            Picker(selection: $infoTabs) {
                ForEach(InfoTabs.allCases, id: \.self) { tab in
                    Text(tab.rawValue).tag(tab)
                }
            } label: {
                Text("Info Tab" + infoTabs.rawValue).foregroundColor(.white).font(.title)
                
            }
            .pickerStyle(.segmented)
            .foregroundColor(.black)
            .background(.ultraThickMaterial)
            .cornerRadius(8)
            
            switch infoTabs {
            case .bio:
                
                Text(aboutMeText)
                    .font(.caption)
                    .padding()
                    .background(.thinMaterial)
                    .cornerRadius(20)
                    .shadow(radius: 2)
                    
                
                
            case .skills:
                SkillsView()
                
            case .experience:
                ExpreienceView()
                
            case .apps:
                ScrollableAppView()
                
            }
            
            
        }
        .padding()
    }
        
    
}

struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        InfoView(aboutMeText: .constant("📱 Mobile App Magician \n 🎓 Master's in Software Dev \n 📲 iOS (Swift) & Flutter Enthusiast \n 2 Years of iOS Dev Experience \n 🚀 Let's bring ideas to life! "))
    }
}
