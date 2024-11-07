//
//  JoinView.swift
//  Health-Assistant
//
//  Created by 강희창 on 11/4/24.
//

import SwiftUI

struct JoinView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var dataManager = DataManager()
    
    @State private var uid: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var showPasswordMismatch: Bool = false
    @State private var showEmailFormatError: Bool = false
    @State private var navigateToEmailLogin: Bool = false
    @State private var showSignUpCompleteMessage = false
    
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
                    HStack {
                        TextFieldView(
                            text: $uid,
                            placeholder: "이메일을 입력하세요",
                            showError: showEmailFormatError,
                            errorColor: .red
                        )
                        Button("중복확인") {
                            
                        }
                        .padding(6)
                        .foregroundStyle(.white)
                        .font(Font.bold16)
                        .background(Color.customGreen)
                        .cornerRadius(8)
                        .onChange(of: uid) {
                            validateEmailFormat()
                        }
                    }
                    if showEmailFormatError {
                        Text("이메일 형식으로 가입해야 합니다")
                            .foregroundColor(.red)
                            .font(Font.regular12)
                            .padding(.top, 5)
                            .padding(.leading, 10)
                    }
                }
                .padding([.leading, .trailing], 40)
                
                VStack(alignment: .leading) {
                    Text("비밀번호")
                        .font(Font.semibold20)
                    TextFieldView(
                        text: $password,
                        placeholder: "비밀번호",
                        isSecure: true
                    )
                }
                .padding([.leading, .trailing], 40)
                .padding(.top, 30)
                
                VStack(alignment: .leading) {
                    Text("비밀번호 확인")
                        .font(Font.semibold20)
                    TextFieldView(
                        text: $confirmPassword,
                        placeholder: "비밀번호 확인",
                        isSecure: true,
                        showError: showPasswordMismatch,
                        errorColor: .red
                    )
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
                .padding([.leading, .trailing], 40)
                .padding(.top, 30)
                
                Button(action: {
                    if validateForm() {
                        dataManager.saveUserData(uid: uid, password: password)
                        showSignUpCompleteMessage = true
                    }
                }) {
                    Text("가입 완료")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(width: 330, height: 50)
                        .background(Color.customGreen)
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
            .navigationBarBackButtonHidden(true)
            .onTapGesture { UIApplication.shared.endEditing() }
            .navigationDestination(isPresented: $navigateToEmailLogin) {
                EmailLoginView(dataManager: dataManager)
            }
            .overlay(
                VStack {
                    if showSignUpCompleteMessage {
                        Text("가입 완료되었습니다!")
                            .font(Font.regular16)
                            .padding()
                            .background(Color.green.opacity(0.8))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .transition(.slide)
                            .onAppear {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                    showSignUpCompleteMessage = false
                                    navigateToEmailLogin = true // 메시지 숨김 후 네비게이션 활성화
                                }
                            }
                    }
                    Spacer()
                }
            )
        }
    }
    
    func validatePasswords() {
        showPasswordMismatch = (password != confirmPassword && !confirmPassword.isEmpty)
    }
    
    func validateEmailFormat() {
        // 간단한 이메일 형식 검사 (정규식 사용)
        let emailPattern = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailPattern)
        showEmailFormatError = !emailPredicate.evaluate(with: uid)
    }
    
    func validateForm() -> Bool {
        // 이메일 형식과 비밀번호 일치 검사
        validateEmailFormat()
        validatePasswords()
        return !showEmailFormatError && !showPasswordMismatch
    }
}

#Preview {
    JoinView()
}
