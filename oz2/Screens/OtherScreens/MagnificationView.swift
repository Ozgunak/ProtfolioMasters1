//
//  MagnificationView.swift
//  oz2
//
//  Created by özgün aksoy on 2023-08-29.
//

import SwiftUI

struct MagnificationView: View {
    
    @State private var currentAmount: CGFloat = 0
    @State private var lastAmount: CGFloat = 0

    var body: some View {
        VStack(spacing: 10) {
            HStack {
                Circle().frame(width: 45, height: 45)
                Text("Ozgun")
                Spacer()
                Image(systemName: "ellipsis")
            }
            .padding(.horizontal)
            Rectangle()
                .frame(height: 300)
                .scaleEffect(1 + currentAmount)
                .gesture(
                MagnificationGesture()
                    .onChanged({ value in
                        currentAmount = value - 1
                    })
                    .onEnded({ value in
                        withAnimation(.spring()) {
                            currentAmount = 0
                        }
                    })
                )
            HStack {
                Image(systemName: "heart.fill")
                Image(systemName: "text.bubble.fill")
                Spacer()
                            }
            .padding(.horizontal)
            .font(.headline)
            Text("Caption for photo")
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
        }
    }
}

struct MagnificationView_Previews: PreviewProvider {
    static var previews: some View {
        MagnificationView()
    }
}
