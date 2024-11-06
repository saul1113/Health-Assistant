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
    @State private var showLoginCompleteMessage = false
    @State private var navigateToMainTab = false
    
    var body: some View {
        NavigationStack {
            VStack {
                VStack(alignment: .leading) {
                    Text("이메일")
                        .font(Font.semibold20)
                    EmailTextField(text: $email)
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
                
                Button("로그인 하기") {
                    login()
                }
                .font(Font.semibold24)
                .foregroundStyle(.white)
                .frame(width: 330, height: 50)
                .background(Color(uiColor: .systemGreen))
                .cornerRadius(8)
                .padding(.top, 80)
            }
            .navigationTitle("로그인")
            .font(Font.bold18)
            .onTapGesture {
                UIApplication.shared.endEditing() // 화면을 탭하면 키보드 내려가도록 함
            }
            .overlay(
                VStack {
                    if showLoginCompleteMessage {
                        Text("로그인 완료되었습니다!")
                            .font(.system(size: 16, weight: .bold))
                            .padding()
                            .background(Color.green.opacity(0.8))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .transition(.slide)
                            .onAppear {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                    showLoginCompleteMessage = false
                                    navigateToMainTab = true // 메시지 숨김 후 네비게이션 활성화
                                }
                            }
                    }
                    Spacer()
                }
                    .padding(.top, 50)
            )
            .fullScreenCover(isPresented: $navigateToMainTab) {
                MainTabView() // MainTabView를 전체 화면에 표시
            }
        }
    }
    private func login() {
        // 로그인 완료 메시지 표시
        showLoginCompleteMessage = true
    }
}

#Preview {
    EmailLoginView()
}
