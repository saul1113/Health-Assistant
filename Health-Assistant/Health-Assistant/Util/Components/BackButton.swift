//
//  BackButton.swift
//  Health-Assistant
//
//  Created by 김수민 on 11/4/24.
//

import SwiftUI

struct BackButton: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }) {
            HStack {
                Image(systemName: "chevron.left")
                    .aspectRatio(contentMode: .fit)
                    .foregroundStyle(.black)
            }
        }
    }
}


