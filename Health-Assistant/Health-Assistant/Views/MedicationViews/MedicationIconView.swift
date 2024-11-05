//
//  MedicationIconView.swift
//  Health-Assistant
//
//  Created by 김수민 on 11/5/24.
//

import SwiftUI

struct MedicationIconView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Text("Hello, World!")
            }
        }
        .navigationTitle("아이콘 추가")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                BackButton()
            }
        }
    }
}

#Preview {
    MedicationIconView()
}
