//
//  ProfileEditView.swift
//  Health-Assistant
//
//  Created by Hwang_Inyoung on 11/5/24.
//

import SwiftUI

struct ProfileEditView: View {
    @ObservedObject var viewModel: ProfileViewModel
    @State private var nickname: String = ""
    
    var body: some View {
        VStack(spacing: 20) {
            TextField("닉네임", text: $nickname)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button("저장") {
                viewModel.updateNickname(nickname)
            }
            .padding()
            .background(Color("CustomGreen"))
            .foregroundColor(.white)
            .cornerRadius(8)
            
            Spacer()
        }
        .padding()
        .navigationTitle("프로필 및 회원정보 수정")
    }
}
