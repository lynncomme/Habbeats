//
//  LockedTaskCard.swift
//  Habbeats
//
//  Created by Konstantin Romashin on 8/9/2567 BE.
//

import SwiftUI

struct LockedTaskCard: View {
    let title: String
    let description: String
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                VStack(alignment: .leading, spacing: 16) {
                    Text(title)
                        .font(.custom("PlayfairDisplay-Regular", size: 14))
                        .foregroundColor(Color("TitleTextColor"))
                        .opacity(0.5)
                    
                    ProgressView(value: 0, total: 1.0)
                        .progressViewStyle(LinearProgressViewStyle())
                        .frame(height: 16)
                        .accentColor(Color("TitleTextColor"))
                        .opacity(0.5)
                    
                    Text(description)
                        .font(.custom("SourceSansPro-Regular", size: 14))
                        .foregroundColor(Color("DescriptionTextColor"))
                        .opacity(0.5)
                }
                .padding(.trailing, 24)
                
                Image(systemName: "lock")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(Color("ArrowColor"))
                    .padding(.trailing)
            }
        }
        .padding()
        .padding(.horizontal, 4)
        .background(Color.clear)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color("BorderColor"), lineWidth: 1)
        )
    }
}
