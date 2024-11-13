//
//  SearchBar.swift
//  Health-Assistant
//
//  Created by 김수민 on 11/13/24.
//

import SwiftUI

struct SearchBar: View {
    @Binding var searchText: String
    @State var isEditing: Bool = false
    var handler: () -> Void
    
    var body: some View {
        HStack {
            TextField("검색어를 입력하세요", text: $searchText).padding()
        .background(Color(.systemGray6))
            .clipShape(.rect(cornerRadius: 18))
            .padding(.horizontal, 10)
            .onSubmit {
                handler()
            }
            .onTapGesture {
                isEditing = true
            }.animation(.easeInOut, value: isEditing)
            if isEditing {
                Button {
                    isEditing = false
                } label: {
                    Text("Cancel")
                }
                .padding(.trailing, 15)
                .transition(.move(edge: .trailing))
            }
        }
    }
}
