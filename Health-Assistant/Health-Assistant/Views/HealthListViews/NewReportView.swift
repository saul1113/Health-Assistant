//
//  NewReportView.swift
//  Health-Assistant
//
//  Created by wonhoKim on 11/4/24.
//

import SwiftUI
//헬스 데이터 가져와서 콘텐트에 넣어줘야함xxxxx -> 헬스데이터 받아온 각각에다가 넣어서 지금은 일단 더미로 편의상 콘텐트에 박음
struct NewReportView: View {
    @Environment(\.dismiss) var dismiss
    @State private var title: String = ""
    @State private var startDate = Date()
    @State private var endDate = Date()
    
    var onSave: (HealthReport) -> Void
    //헬스데이터 받아오는거 보고 데이트 피커 선택 조건 걸어야함 
    var body: some View {
        NavigationView {
            Form {
                TextField("리포트 제목", text: $title)
                DatePicker("시작 날짜", selection: $startDate, displayedComponents: .date)
                DatePicker("종료 날짜", selection: $endDate, displayedComponents: .date)
            }
            .navigationTitle("새 리포트")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("취소") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("저장") {
                        let newReport = HealthReport(id: UUID().hashValue, title: title, startDate: startDate, endDate: endDate, content: """
                                                     ## 2024-10-01
                                                     
                                                     ### 수면

                                                     - 그래프: 수면 시간, 깊은 수면, 얕은 수면 비율
                                                     - 호흡수: 16회/분
                                                     - 심박수: 72회/분
                                                     - 체온: 36.5°C

                                                     ### 심박수

                                                     - 그래프: 심박수 변화 추이
                                                     - 평균 심박수: 68회/분
                                                     - 휴식기 심박수: 60회/분
                                                     - 심전도: 정상

                                                     ### 산소포화도

                                                     - 산소포화도: 98%

                                                     ---

                                                     ## 2024-10-02

                                                     수면

                                                     - 그래프: 수면 시간, 깊은 수면, 얕은 수면 비율
                                                     - 호흡수: 15회/분
                                                     - 심박수: 70회/분
                                                     - 체온: 36.4°C

                                                     ### 심박수

                                                     - 그래프: 심박수 변화 추이
                                                     - 평균 심박수: 69회/분
                                                     - 휴식기 심박수: 61회/분
                                                     - 심전도: 정상

                                                     ### 산소포화도

                                                     - 산소포화도: 97%

                                                     ---

                                                     ## 2024-10-03

                                                     ### 수면

                                                     - 그래프: 수면 시간, 깊은 수면, 얕은 수면 비율
                                                     - 호흡수: 17회/분
                                                     - 심박수: 73회/분
                                                     - 체온: 36.6°C

                                                     ### 심박수

                                                     - 그래프: 심박수 변화 추이
                                                     - 평균 심박수: 70회/분
                                                     - 휴식기 심박수: 62회/분
                                                     - 심전도: 정상

                                                     ### 산소포화도

                                                     - 산소포화도: 96%
                                                     
                                                     _이 리포트는 건강 데이터를 기준으로 생성되었습니다._
                                                     """)
                                                     
                        onSave(newReport)
                        dismiss()
                    }
                }
            }
        }
    }
}
