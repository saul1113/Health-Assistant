//
//  ProfileSetting.swift
//  Health-Assistant
//
//  Created by 강희창 on 11/4/24.
//

import SwiftUI

struct ProfileSetting: View {
    @State var text: String = ""
    @State private var nicknameMiss: Bool = false
    
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                Text("이름")
                    .bold()
                CustomTextField()
            }
            .padding(.leading, 40)
            .padding(.trailing, 40)
            
            VStack(alignment: .leading) {
                Text("닉네임")
                    .bold()
                HStack {
                    nickNameText()
                    Button("중복확인") {
                        
                    }
                    .padding(10)
                    .foregroundStyle(.white)
                    .bold()
                    .background(Color(uiColor: .systemGreen))
                    .cornerRadius(8)
                }
            }
            .padding(.leading, 40)
            .padding(.trailing, 40)
            .padding(.top, 30)
            
            VStack(alignment: .leading) {
                Text("생년월일")
                    .bold()
                birthDayText()
            }
            .padding(.leading, 40)
            .padding(.trailing, 40)
            .padding(.top, 30)
        }
    }
    
    func nickNameText() -> some View {
        TextField("2자 - 10자사이로 입력해주세요.", text: $text)
            .frame(height: 35)
            .padding(.leading, 10)
            .overlay {
                RoundedRectangle(cornerRadius: 5)
                    .stroke(nicknameMiss ? Color.red : Color.black, lineWidth: 0.3)
            }
    }
    
    func birthDayText() -> some View {
        TextField("8자리로 입력해주세요.", text: $text)
            .frame(height: 35)
            .padding(.leading, 10)
            .overlay {
                RoundedRectangle(cornerRadius: 5)
                    .stroke(Color.black, lineWidth: 0.3)
            }
    }
}

#Preview {
    ProfileSetting()
}
