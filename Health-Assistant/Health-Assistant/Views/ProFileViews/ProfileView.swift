//
//  ProFileView.swift
//  Health-Assistant
//
//  Created by Hwang_Inyoung on 11/1/24.
//

import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                VStack(spacing: 10) {
                    ZStack(alignment: .bottomTrailing) {
                        Circle()
                            .fill(Color("CustomGreen"))
                            .frame(width: 100, height: 100)
                            .overlay(
                                Image(systemName: "waveform.path.ecg")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 60, height: 60)
                                    .foregroundColor(.white)
                            )
                        
                        Circle()
                            .fill(Color.gray.opacity(0.8))
                            .frame(width: 24, height: 24)
                            .overlay(
                                Image(systemName: "camera.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 12, height: 12)
                                    .foregroundColor(.white)
                            )
                            .offset(x: -8, y: -8)
                    }
                    
                    Text(viewModel.profile.nickname)
                        .font(.bold24)
                        .fontWeight(.medium)
                    
                    Text(viewModel.profile.birthDate)
                        .font(.regular16)
                        .foregroundColor(.gray)
                    
                    Text(viewModel.profile.bloodType)
                        .font(.regular16)
                        .foregroundColor(.gray)
                }
                
                Divider()
                    .background(Color("CustomGreen").opacity(0.5))
                
                List {
                    NavigationLink(destination: ProfileEditView(viewModel: viewModel)) {
                        HStack {
                            Text("프로필 및 회원정보 수정")
                                .font(.medium16)
                        }
                    }
                    NavigationLink(destination: PasswordChangeView()) {
                        HStack {
                            Text("비밀번호 변경")
                                .font(.medium16)
                        }
                    }
                    NavigationLink(destination: NotificationSettingsView()) {
                        HStack {
                            Text("알림 수신 설정")
                                .font(.medium16)
                        }
                    }
                    NavigationLink(destination: AccountManagementView()) {
                        HStack {
                            Text("계정 / 정보 관리")
                                .font(.medium16)
                        }
                    }
                    NavigationLink(destination: AccountDeletionView()) {
                        HStack {
                            Text("회원 탈퇴")
                                .font(.medium16)
                        }
                    }
                }
                .listStyle(PlainListStyle())
                .padding(.top, -10)
                
                Spacer()
                
                // 가운데 하단에 로그아웃 버튼 추가
                Button(action: {
                    // 로그아웃 기능 구현
                }) {
                    Text("로그아웃")
                        .font(.medium16)
                        .foregroundColor(.gray)
                        .padding()
                }
                .padding()
            }
            .navigationTitle("프로필")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    ProfileView()
}
