//
//  HealthSheetView.swift
//  Health-Assistant
//
//  Created by 강희창 on 11/4/24.
//

import SwiftUI
import HealthKit

struct HealthConnectSheet: View {
    @Environment(\.dismiss) var dismiss
    private let healthKitManager = HealthKitManager()
    @Binding var navigateToHome: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            Image("HealthLogo")
                .resizable()
                .frame(width: 100, height: 100)
            
            Text("건강 앱과 연결하시겠습니까?")
                .font(.semibold24)
                .padding()
            
            Text("이 앱을 사용하기 위해서는 건강 데이터 접근 권한이 필요합니다.")
                .font(Font.regular16)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
            
            HStack(spacing: 100) {
                Button("취소") {
                    dismiss()
                }
                .foregroundColor(.red)
                
                Button("허용") {
                    dismiss()
                    requestHealthKitAuthorization()
                }
                .foregroundColor(.blue)
            }
            .padding()
        }
        .padding()
    }
    private func requestHealthKitAuthorization() {
        healthKitManager.requestAuthorization { success, error in
            if success {
                print("HealthKit 접근 권한이 허용되었습니다.")
                dismiss()
                navigateToHome = true // HomeView로 이동
            } else {
                print("HealthKit 접근 권한 요청 실패: \(error?.localizedDescription ?? "알 수 없는 오류")")
                dismiss()
            }
        }
    }
}

#Preview {
    HealthConnectSheet(navigateToHome: .constant(false))
}
