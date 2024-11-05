//
//  MedicationSearchView.swift
//  Health-Assistant
//
//  Created by 김수민 on 11/4/24.
//

import SwiftUI

struct MedicationSearchView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Text("Hello, World!")
            }
        }
        .navigationTitle("약 검색")
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
    MedicationSearchView()
}
