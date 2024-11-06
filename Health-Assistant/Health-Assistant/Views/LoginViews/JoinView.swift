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
    @State private var navigateToProfileSetting = false
    @State private var showEmailFormatError: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                Image("HAHALogo")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .padding(.bottom, 40)
                
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
                
                NavigationLink(destination: ProfileSetting()) {
                                    Text("다 음")
                                        .font(Font.semibold24)
                                        .foregroundStyle(.white)
                                        .frame(width: 330, height: 50)
                                        .background(Color.CustomGreen)
                                        .cornerRadius(8)
                                        .padding(.top, 80)
                                }
                            }
            .navigationTitle("회원가입")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        BackButton()
                    }
                }
            }
            .onTapGesture {
                UIApplication.shared.endEditing()
            }
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
