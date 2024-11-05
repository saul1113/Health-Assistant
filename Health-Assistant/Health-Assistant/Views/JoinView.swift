//
//  JoinView.swift
//  Health-Assistant
//
//  Created by 강희창 on 11/4/24.
//

import SwiftUI

struct JoinView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var showPasswordMismatch: Bool = false
    
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
            
            VStack(alignment: .leading) {
                Text("비밀번호 확인")
                    .bold()
                passwordtextField()
                    .onChange(of: confirmPassword) { _ in
                        validatePasswords()
                    }
                if showPasswordMismatch {
                    Text("비밀번호가 일치하지 않습니다")
                        .foregroundColor(.red)
                        .font(.caption)
                        .padding(.top, 5)
                        .padding(.leading, 10)
                }
            }
            .padding(.leading, 40)
            .padding(.trailing, 40)
            .padding(.top, 30)
            
            Button("가입하기") {
                
            }
            .font(.title2)
            .bold()
            .foregroundStyle(.white)
            .frame(width: 330, height: 50)
            .background(Color(uiColor: .systemGreen))
            .cornerRadius(8)
            .padding(.top, 80)
        }
        .navigationTitle("회원가입")
        .onTapGesture {
            UIApplication.shared.endEditing() // 화면을 탭하면 키보드 내려가도록 함
        }
    }
    
    func passwordtextField() -> some View {
        SecureField("비밀번호 확인", text: $confirmPassword)
            .frame(height: 35)
            .padding(.leading, 10)
            .overlay {
                RoundedRectangle(cornerRadius: 5)
                    .stroke(showPasswordMismatch ? Color.red : Color.black, lineWidth: 0.3)
            }
    }
    func validatePasswords() {
        showPasswordMismatch = (password != confirmPassword && !confirmPassword.isEmpty)
    }
}

#Preview {
    JoinView()
}
