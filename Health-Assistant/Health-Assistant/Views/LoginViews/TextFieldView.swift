//
//  TextFieldView.swift
//  Health-Assistant
//
//  Created by 강희창 on 11/4/24.
//

import SwiftUI

struct EmailTextField: View {
    @Binding var text: String
    
    var body: some View {
        TextField("email.example.com",text: $text )
            .font(Font.regular14)
            .frame(height: 35)
            .padding(.leading, 10)
            .overlay {
                RoundedRectangle(cornerRadius: 5)
                    .stroke(Color.black, lineWidth: 0.3)
            }
    }
}

struct PasswordTextField: View {
    @Binding var text: String
    
    var body: some View {
        VStack {
            SecureField("6자~20자 사이로 입력해주세요.",text: $text )
                .font(Font.regular14)
                .frame(height: 35)
                .padding(.leading, 10)
                .overlay {
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.black, lineWidth: 0.3)
                }
        }
    }
}

struct CustomTextField: View {
    @State private var text: String = ""
    
    var body: some View {
        TextField("",text: $text )
            .frame(height: 35)
            .padding(.leading, 10)
            .overlay {
                RoundedRectangle(cornerRadius: 5)
                    .stroke(Color.black, lineWidth: 0.3)
            }
    }
}

struct NickNameTextField: View {
    @Binding var text: String
    @Binding var error: String?
    @Binding var isAvailable: Bool?
    
    var body: some View {
        TextField("2자 - 10자사이로 입력해주세요.", text: $text)
            .font(Font.regular14)
            .frame(height: 35)
            .padding(.leading, 10)
            .onChange(of: text) { newValue in
                if newValue.isEmpty {
                    // 텍스트가 비어 있으면 기본 상태로 복원
                    error = nil
                    isAvailable = nil
                } else if newValue.count < 2 || newValue.count > 10 {
                    // 2글자 미만이거나 10글자 초과일 때 에러 설정
                    error = "닉네임은 2글자 이상 10자 이내로 설정하여주세요."
                    isAvailable = nil
                } else {
                    // 유효한 입력일 때 에러 제거
                    error = nil
                }
            }
            .overlay {
                RoundedRectangle(cornerRadius: 5)
                    .stroke(isAvailable == true ? Color.blue : (error != nil || isAvailable == false ? Color.red : Color.black), lineWidth: 0.3)
            }
    }
}

struct BirthDayTextField: View {
    @Binding var text: String
    @Binding var error: String?
    
    var body: some View {
        TextField("숫자 8자리로 입력해주세요.", text: $text)
            .font(Font.regular14)
            .frame(height: 35)
            .padding(.leading, 10)
            .onChange(of: text) { newValue in
                if newValue.isEmpty {
                    error = nil // 비어 있을 때 에러 메시지를 제거하여 기본 상태로
                } else if newValue.count != 8 || Int(newValue) == nil {
                    error = "생년월일은 숫자 8자리로 입력해주세요." // 8자리 숫자가 아닐 때 에러 메시지 표시
                } else {
                    error = nil
                }
            }
            .overlay {
                RoundedRectangle(cornerRadius: 5)
                    .stroke(error != nil ? Color.red : Color.black, lineWidth: 0.3)
            }
    }
}

extension UIApplication {
    func endEditing() {
        // 현재 포커스된 뷰의 포커스를 해제하여 키보드를 내림
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
