//
//  TextFieldView.swift
//  Health-Assistant
//
//  Created by 강희창 on 11/4/24.
//

import SwiftUI

struct TextFieldView: View {
    @Binding var text: String
    var placeholder: String
    var isSecure: Bool = false
    var showError: Bool = false
    var errorColor: Color = .red
    var onTextChange: ((String) -> Void)?
    
    var body: some View {
        VStack(alignment: .leading) {
            if isSecure {
                SecureField(placeholder, text: $text)
                    .padding(.horizontal, 10)
                    .frame(height: 35)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(showError ? errorColor : Color.black, lineWidth: 0.3)
                    )
                    .onChange(of: text, perform: { newValue in
                        onTextChange?(newValue) // 텍스트 변경 시 검증 클로저 호출
                    })
            } else {
                TextField(placeholder, text: $text)
                    .padding(.horizontal, 10) // 내부 패딩
                    .frame(height: 35)
                    .background(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(showError ? errorColor : Color.black, lineWidth: 0.3)
                    )
                    .onChange(of: text, perform: { newValue in
                        onTextChange?(newValue) // 텍스트 변경 시 검증 클로저 호출
                    })
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
