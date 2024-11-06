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
        VStack {
            TextField("email.example.com",text: $text )
                .frame(height: 35)
                .padding(.leading, 10)
                .overlay {
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.black, lineWidth: 0.3)
                }
        }
    }
}

struct PasswordTextField: View {
    @Binding var text: String
    
    var body: some View {
        VStack {
            SecureField("6자~20자 사이로 입력해주세요.",text: $text )
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
        VStack {
            TextField("",text: $text )
                .frame(height: 35)
                .padding(.leading, 10)
                .overlay {
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.black, lineWidth: 0.3)
                }
        }
    }
}

extension UIApplication {
    func endEditing() {
        // 현재 포커스된 뷰의 포커스를 해제하여 키보드를 내림
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
