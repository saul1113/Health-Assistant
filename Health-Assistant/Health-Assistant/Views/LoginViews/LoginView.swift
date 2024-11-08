//
//  LoginView.swift
//  Health-Assistant
//
//  Created by 강희창 on 11/3/24.
//

import SwiftUI

struct LoginView: View {
    @Environment(\.dismiss) var dismiss
    @State private var showJoinView = false
    @State private var showEmailLoginView = false
    
    var body: some View {
        NavigationStack {
            VStack {
                logoSection
                socialLoginSection
                emailLoginAndSignUpSection
            }
            .toolbar { leadingNavigationBar }
            .navigationBarBackButtonHidden(true)
            .background(Color(uiColor: .systemBackground))
            .navigationDestination(isPresented: $showEmailLoginView) {
                EmailLoginView()
            }
            .navigationDestination(isPresented: $showJoinView) {
                JoinView()
            }
        }
    }
    
    // MARK: - 로고
    private var logoSection: some View {
        VStack {
            Image("HAHALogo")
                .resizable()
                .frame(width: 100, height: 100)
            HStack {
                Text("HAHA")
                    .foregroundStyle(Color.customGreen)
                    .font(Font.bold24)
                + Text("와 함께")
                    .font(Font.bold20)
            }
            HStack(spacing: 0) {
                Text("건강 관리")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.black)
                    .padding(.horizontal, 5)
                    .background(Color.customGreen.opacity(0.3))
                    .cornerRadius(5)
                
                Text("를 시작하세요!")
                    .font(Font.bold20)
            }
            
            Text("검사지 검색부터 스케줄관리 까지")
                .foregroundStyle(Color(uiColor: .systemGray))
                .font(Font.semibold14)
        }
        .padding(.bottom, 40)
    }
    
    // MARK: - 소셜로그인
    private var socialLoginSection: some View {
        VStack {
            Text("소셜 계정으로 로그인하기")
                .font(Font.semibold14)
            
            HStack(spacing: 20) {
                socialLoginButton(imageName: "GoogleLogo")
                socialLoginButton(imageName: "AppleLogo")
            }
        }
        .padding(.top, 100)
    }
    // MARK: - 로그인 및 회원가입
    private var emailLoginAndSignUpSection: some View {
        VStack {
            NavigationLink(destination: EmailLoginView()) {
                loginButtonContent
            }
            .buttonStyle(PlainButtonStyle())
            
            HStack(spacing: 20) {
                NavigationLink(destination: JoinView()) {
                    Text("회원가입")
                        .font(Font.semibold14)
                }
                
                Text(" | ")
                    .font(.caption)
                
                Button("문의하기") {
                    // 문의하기 액션
                }
                .font(Font.semibold14)
            }
            .padding()
        }
        .navigationBarBackButtonHidden(true)
        .padding()
    }
    
    // MARK: - 컴포넌트
    private var loginButtonContent: some View {
        HStack {
            Image(systemName: "envelope.fill")
                .foregroundColor(.gray)
            Text("이메일로 로그인")
                .foregroundColor(.gray)
                .font(Font.semibold14)
        }
        .frame(width: 250)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.gray, lineWidth: 0.5)
        )
    }
    
    private func socialLoginButton(imageName: String) -> some View {
        Button(action: {
            // 소셜 로그인 액션
        }) {
            Image(imageName)
                .resizable()
                .clipShape(Circle())
                .frame(width: 50, height: 50)
        }
    }
    
    private var leadingNavigationBar: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button(action: {
                dismiss()
            }) {
                BackButton()
            }
        }
    }
}
#Preview {
    LoginView()
}
