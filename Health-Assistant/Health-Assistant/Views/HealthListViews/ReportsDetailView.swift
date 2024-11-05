import SwiftUI
import MarkdownUI

struct ReportsDetailView: View {
    
    var reports: [HealthReport]
    private var sortedReports: [HealthReport] {
        reports.sorted { $0.reportDate < $1.reportDate }
    }
    
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
                        - 평균 심박수: \(report.heartRate)회/분
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
                    """)
                    .padding()
                }
            }
            .navigationTitle(reports.first?.title ?? "보고서")
            .navigationBarTitleDisplayMode(.inline)
        }
        .padding()
    }
}
