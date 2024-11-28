//
//  DayHeadersView.swift
//  Health-Assistant
//
//  Created by Hwang_Inyoung on 11/10/24.
//

import SwiftUI

struct DayHeadersView: View {
    var body: some View {
        HStack {
            ForEach(["일", "월", "화", "수", "목", "금", "토"], id: \.self) { day in
                Text(day)
                    .frame(maxWidth: .infinity)
                    .font(.medium18)
                    .foregroundStyle(.black)
            }
        }
    }
}
