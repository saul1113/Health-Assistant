//
//  HealthAllowView.swift
//  Health-Assistant
//
//  Created by 강희창 on 11/4/24.
//

import SwiftUI
import HealthKit

struct HealthAllowView: View {
    @Environment(\.dismiss) var dismiss
    private let healthKitManager = HealthKitManager()
    @State private var showHealthConnectSheet = false
    @State private var navigateLogin = false
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                Text("안녕하세요, 갓재민님!")
                    .font(Font.bold30)
                    .foregroundStyle(.white)
                
                VStack(alignment: .leading) {
                    Text("HAHA와 함께 하기 위해")
                    Text("건강데이터를 엑세스 해주세요.")
                }
                .font(Font.medium20)
                .foregroundStyle(.white)
                .padding(.top, 20)
                
                VStack(alignment: .leading) {
                    
                    VStack(spacing: 20) {
                        Text("* 건강앱 연동을 건너뛰어도 이용이 가능합니다.\n   단, 건강데이터를 활용한 이용에 대하여 제한 됩니다.")
                            .font(Font.regular14)
                        
                        
                        Button("시작하기") {
                            navigateLogin = true
                        }
                        .font(Font.semibold24)
                        .foregroundStyle(Color.customGreen)
                        .frame(width: 330, height: 50)
                        .background(.white)
                        .cornerRadius(8)
                    }
                    .padding(.top, 50)
                }
                .padding(.top, 200)
            }
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        BackButton()
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.customGreen) // 전체 배경색 설정
            .sheet(isPresented: $showHealthConnectSheet) {
                HealthConnectSheet(navigateToHome: $navigateLogin)
                    .presentationDetents([.fraction(0.5)])
            }
            .navigationDestination(isPresented: $navigateLogin) {
                LoginView()
            }
        }
    }
}

#Preview {
    HealthAllowView()
}
