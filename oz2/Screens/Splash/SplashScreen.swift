//
//  SplashScreen.swift
//  oz2
//
//  Created by özgün aksoy on 2023-08-02.
//

import SwiftUI

struct SplashScreen: View {
    var body: some View {
        ZStack {
            Color(.darkGray).ignoresSafeArea()
            VStack {
                Image("plusButton").clipShape(Circle())
            }
        }
    }
}

struct SplashScreen_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreen()
    }
}
