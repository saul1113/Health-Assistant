//
//  JoinView.swift
//  Health-Assistant
//
//  Created by 강희창 on 11/4/24.
//

import SwiftUI

struct JoinView: View {
    @Environment(\.dismiss) var dismiss
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var showPasswordMismatch: Bool = false
    @State private var showSignupCompleteMessage = false
    @State private var showEmailFormatError: Bool = false
    
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                Text("이메일")
                    .font(Font.semibold20)
                EmailTextField(text: $email)
                    .onChange(of: email) {
                        validateEmailFormat()
                    }
                    .overlay {
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(showEmailFormatError ? Color.red : Color.black, lineWidth: 0.3)
                    }
                if showEmailFormatError {
                    Text("이메일 형식으로 가입해야 합니다")
                        .foregroundColor(.red)
                        .font(Font.regular12)
                        .padding(.top, 5)
                        .padding(.leading, 10)
                }
            }
            .padding(.leading, 40)
            .padding(.trailing, 40)
            
            VStack(alignment: .leading) {
                Text("비밀번호")
                    .font(Font.semibold20)
                PasswordTextField(text: $password)
            }
            .padding(.leading, 40)
            .padding(.trailing, 40)
            .padding(.top, 30)
            
            VStack(alignment: .leading) {
                Text("비밀번호 확인")
                    .font(Font.semibold20)
                passwordtextField()
                    .onChange(of: confirmPassword) {
                        validatePasswords()
                    }
                if showPasswordMismatch {
                    Text("비밀번호가 일치하지 않습니다")
                        .foregroundColor(.red)
                        .font(Font.regular12)
                        .padding(.top, 5)
                        .padding(.leading, 10)
                }
            }
            .padding(.leading, 40)
            .padding(.trailing, 40)
            .padding(.top, 30)
            
            Button("가입하기") {
                if validateForm() {
                    saveUserData() // 회원 데이터 저장
                    showSignupCompleteMessage = true // 가입 완료 메시지 표시
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        dismiss() // 홈 화면으로 돌아가기
                    }
                }
            }
            .font(Font.semibold24)
            .foregroundStyle(.white)
            .frame(width: 330, height: 50)
            .background(Color(uiColor: .systemGreen))
            .cornerRadius(8)
            .padding(.top, 80)
        }
        .navigationTitle("회원가입")
        .font(Font.bold18)
        .onTapGesture {
            UIApplication.shared.endEditing()
        }
        .overlay(
            VStack {
                if showSignupCompleteMessage {
                    Text("가입이 완료되었습니다!")
                        .font(.system(size: 16, weight: .bold))
                        .padding()
                        .background(Color.green.opacity(0.8))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .transition(.slide)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                showSignupCompleteMessage = false
                            }
                        }
                }
                Spacer()
            }
                .padding(.top, 50)
        )
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
    
    func validateEmailFormat() {
        // 간단한 이메일 형식 검사 (정규식 사용)
        let emailPattern = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailPattern)
        showEmailFormatError = !emailPredicate.evaluate(with: email)
    }
    
    func validateForm() -> Bool {
        // 이메일 형식과 비밀번호 일치 검사
        validateEmailFormat()
        validatePasswords()
        return !showEmailFormatError && !showPasswordMismatch
    }
    
    func saveUserData() {
        // 서버 없이 데이터 저장 예제
        UserDefaults.standard.set(email, forKey: "userEmail")
        UserDefaults.standard.set(password, forKey: "userPassword")
    }
}

#Preview {
    JoinView()
}
