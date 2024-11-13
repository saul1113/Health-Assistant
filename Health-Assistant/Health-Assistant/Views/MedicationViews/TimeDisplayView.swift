//
//  TimeDisplayView.swift
//  Health-Assistant
//
//  Created by 김수민 on 11/12/24.
//

import SwiftUI

struct TimeDisplayView: View {
    let time: String
    @Binding var selectedTimes: [Date]
    
    var body: some View {
        let components = time.split(separator: " ")
        let first = components[0]
        let second = components[1]
        
        let formatFirst = first.replacingOccurrences(of: ":", with: " : ")
        
        return HStack(spacing: 10) {
            Text(formatFirst)
                .font(.medium28)
                .foregroundColor(.black)
            
            Text(second)
                .font(.regular16)
                .foregroundColor(.black)
                .padding(.top, 7)
            
            
            
            Button(action: {
                if let index = selectedTimes.firstIndex(where: { formatTimeToString($0) == time }) {
                    selectedTimes.remove(at: index)
                }
            }) {
                Image(systemName: "minus.circle.fill")
                    .foregroundColor(.red.opacity(0.8))
                    .font(.system(size: 24))
            }
        }
        
    }
}
