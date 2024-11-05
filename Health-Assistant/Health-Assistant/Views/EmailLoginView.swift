//
//  EmailLoginView.swift
//  Health-Assistant
//
//  Created by 강희창 on 11/4/24.
//

import SwiftUI

struct EmailLoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                Text("이메일")
                    .bold()
                EmailTextField(text: $email)
            }
            .padding(.leading, 40)
            .padding(.trailing, 40)
            
            VStack(alignment: .leading) {
                Text("비밀번호")
                    .bold()
                PasswordTextField(text: $password)
            }
            .padding(.leading, 40)
            .padding(.trailing, 40)
            .padding(.top, 30)
            
            Button("로그인 하기") {
                
            }
            .font(.title2)
            .bold()
            .foregroundStyle(.white)
            .frame(width: 330, height: 50)
            .background(Color(uiColor: .systemGreen))
            .cornerRadius(8)
            .padding(.top, 80)
        }
        .navigationTitle("로그인")
        .onTapGesture {
            UIApplication.shared.endEditing() // 화면을 탭하면 키보드 내려가도록 함
        }
    }
}

#Preview {
    EmailLoginView()
}
