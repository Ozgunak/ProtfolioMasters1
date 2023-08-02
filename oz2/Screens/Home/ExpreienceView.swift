//
//  ExpreienceView.swift
//  oz2
//
//  Created by özgün aksoy on 2023-07-29.
//

import SwiftUI

struct ExpreienceView: View {
    @State var experienceList: [ExperienceModel] = [ExperienceModel(id: 0, companyName: "Mobven", startYear: 2022, endYear: 2023, totalYear: 2, position: "iOS Developer"),
                                                    ExperienceModel(id: 1, companyName: "TUSAS", startYear: 2020, endYear: 2022, totalYear: 3, position: "Mechanical Engineer"),
                                                    ExperienceModel(id: 2, companyName: "KES KLIMA", startYear: 2018, endYear: 2020, totalYear: 2, position: "R&D Engineer")]
    
    
    var body: some View {
        VStack (alignment: .leading) {
            Text("Experiences")
                .font(.title2)
                .padding(.bottom, 4)
            
            ForEach(experienceList) { experience in
                HStack {
                    Text(experience.companyName)
                        .font(.title3)
                    Text("")
                    Spacer()
                    Text(experience.position)
                        .font(.body)
//                    Text(String(experience.startYear))
//                        .font(.caption)
//                    Text(String(experience.endYear))
//                        .font(.caption)

                    Text("(\(experience.totalYear) years)")
                        .font(.caption)

                    
                    
                }
            }
            
        }
        .padding()
        .background(.thinMaterial)
        .cornerRadius(20)
        .shadow(radius: 2)
    }
}

struct ExperienceModel: Identifiable {
    var id: Int
    let companyName: String
    let startYear: Int
    let endYear: Int
    let totalYear: Int
    let position: String
}
struct ExpreienceView_Previews: PreviewProvider {
    static var previews: some View {
        ExpreienceView()
    }
}
