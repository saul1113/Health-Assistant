//
//  NewReportView.swift
//  Health-Assistant
//
//  Created by wonhoKim on 11/4/24.
//


import SwiftUI
import MarkdownUI

struct ReportsDetailView: View {
    var reportSummary: HealthReportSummary
    
    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading) {
                    Markdown("""
                                           # 건강 데이터 보고서
                                           ---
                                           
                                           \(sortedReports.map { report in
                                               """
                                               ## \(report.reportDate)
                                               
                                               ### 수면
                                               - 수면 데이터 추가 예정
                                               
                                               ### 심박수
                                               - 그래프: 추가 예정
                                               - 평균 심박수: \(report.heartRate)회
                                               - 휴식기 심박수: 추가예정
                                               - 심전도: 추가예정
                                               
                                               ### 산소포화도
                                               - 산소포화도: \(report.oxygenSaturation)%
                                               
                                               ### 체온
                                               - 평균 체온: \(report.temperature)°C
                                               ---
                                               """
                                           }.joined(separator: "\n"))
                                           
                                           _이 리포트는 건강 데이터를 기준으로 생성되었습니다._
                                           _현재 테스트 중으로 데이터가 부정확 할 수 있습니다._
                                           _건강앱에 기록되지 않은 데이터는 0.0으로 출력됩니다._
                                           """)
                    .padding()
                }
            }
            .navigationTitle(reportSummary.title)
            .navigationBarTitleDisplayMode(.inline)
            //툴바에 아이콘 추가
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                    //pdf 공유 관련
                        print("아직 안되지롱 흐흐")
                    }) {
                        Image(systemName:"square.and.arrow.up")
                    }
                }
            }
        }
        .padding()
    }
    
    // 날짜 기준으로 리포트를 정렬
    private var sortedReports: [HealthReport] {
        reportSummary.healthReports.sorted(by: { $0.date < $1.date })
    }
}
