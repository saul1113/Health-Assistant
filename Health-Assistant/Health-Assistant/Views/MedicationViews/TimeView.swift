//
//  TimeView.swift
//  Health-Assistant
//
//  Created by 김수민 on 11/7/24.
//

import SwiftUI

struct TimeView: View {
    let time: String
    
    var body: some View {
        let components = time.split(separator: " ")
        let first = components[0]
        let second = components[1]
        
        let formatFirst = first.replacingOccurrences(of: ":", with: " : ")
        
        return HStack(spacing: 10) {
            Text(formatFirst)
                .font(.medium30)
                .foregroundColor(.black)
            
            Text(second)
                .font(.regular18)
                .foregroundColor(.black)
                .padding(.top, 7)
        }
    }
}

