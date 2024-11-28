//
//  AccountDeletionView.swift
//  Health-Assistant
//
//  Created by Hwang_Inyoung on 11/5/24.
//

import SwiftUI

struct AccountDeletionView: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("계정을 삭제하시겠습니까?")
                .font(.headline)
                .padding()
            
            Button("회원탈퇴") {
                // 회원탈퇴 로직 추가
            }
            .padding()
            .background(Color.red)
            .foregroundColor(.white)
            .cornerRadius(8)
            
            Spacer()
        }
        .padding()
        .navigationTitle("회원탈퇴")
    }
}
