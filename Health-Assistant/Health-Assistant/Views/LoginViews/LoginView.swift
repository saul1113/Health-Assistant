//
//  LoginView.swift
//  Health-Assistant
//
//  Created by 강희창 on 11/3/24.
//

import SwiftUI

struct LoginView: View {
    @State private var textField: String = ""
    
    var body: some View {
        NavigationView {
        VStack {
            VStack {
                Image("HAHALogo")
                    .resizable()
                    .frame(width: 100, height: 100)
                HStack {
                    Text("HAHA")
                        .foregroundStyle(Color(uiColor: .systemGreen))
                        .font(Font.bold24)
                    
                    + Text("와 함께")
                        .font(Font.bold20)
                }
               
                    HStack(spacing: 0) {
                            Text("건강 관리")
                            .font(Font.bold20)
                                .foregroundColor(.black)
                                .background(Color(uiColor: .systemGreen).opacity(0.3))
                                .cornerRadius(5)
                        
                        Text("를 시작하세요!")
                            .font(Font.bold20)
                    }
                    
                Text("검사지 검색부터 스케줄관리 까지")
                    .foregroundStyle(Color(uiColor: .systemGray))
                    .font(Font.semibold14)
            }
            
            VStack {
                Text ("소셜 계정으로 로그인하기")
                    .font(Font.semibold14)
                
                HStack {
                    Button {
                        
                    } label: {
                        Image("GoogleLogo")
                            .resizable()
                            .clipShape(Circle())
                            .frame(width: 50, height: 50)
                        //                            .overlay(Circle().stroke(Color.black))
                    }
                    
                    Button {
                        
                    } label: {
                        Image("AppleLogo")
                            .resizable()
                            .clipShape(Circle())
                            .frame(width: 50, height: 50)
                    }
                    .padding(.leading, 20)
                    
                }
                .padding()
            }
            .padding(.top, 100)
            
                VStack {
                    NavigationLink(destination: EmailLoginView()) {
                        HStack {
                            Image(systemName: "envelope.fill")
                                .foregroundColor(.gray)
                            Text("이메일로 로그인")
                                .foregroundColor(.gray)
                                .font(Font.semibold14)
                        }
                        .frame(width: 250)
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray, lineWidth: 0.5)
                        )
                    }
                    
                    HStack(spacing: 20) {
                        NavigationLink(destination: JoinView()) {
                            Text("회원가입")
                        }
                        .font(Font.semibold14)
                        
                        Text(" | ")
                            .font(.caption)
                        
                        Button("문의하기") {
                            
                        }
                        .font(Font.semibold14)
                    }
                    .padding()
                }
                .padding()
            }
        }
    }
}

#Preview {
    LoginView()
}
