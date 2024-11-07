//
//  PDFViewModel.swift
//  Health-Assistant
//
//  Created by wonhoKim on 11/4/24.
//

import SwiftUI
import MarkdownUI
//- 수면시간 다른어플 참고해서 어케 할지 고쳐놓을게요
class PDFViewModel: ObservableObject {
    @Published var pdfURL: URL?
    
    // Markdown 형식의 텍스트 생성 함수
    func generateMarkdown(from reportSummary: HealthReportSummary) -> String {
        
        let markdownContent = """
                # 건강 데이터 보고서
                ---
                
                \(reportSummary.healthReports.sorted(by: { $0.date < $1.date }).map { report in
                """
                ## \(report.reportDate)
                
                ### 수면
                - 코어 수면 시간: \(report.asleepCoreTime.hours)시간 \(report.asleepCoreTime.minutes)분
                - 깊은 수면 시간: \(report.asleepDeepTime.hours)시간 \(report.asleepDeepTime.minutes)분
                - 램 수면 시간: \(report.asleepREMTime.hours)시간 \(report.asleepREMTime.minutes)분
                
                
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
                """
        return markdownContent
    }
    
    func convertToHoursAndMinutes(minutes: Double) -> (hours: Int, minutes: Int) {
        let hours = Int(minutes) / 60
        let remainingMinutes = Int(minutes) % 60
        return (hours, remainingMinutes)
    }
    
    // PDF 생성 함수
    //만들고 있었는데 필요한 데이터들 다 추가한후 해야 사이즈 조절 같은게 가능할것 같아서 일단 주석처리
    //    @MainActor func createPDF(from reportSummary: HealthReportSummary) {
    //        let markdownText = generateMarkdown(from: reportSummary)
    //        let markdownView = Markdown(markdownText)
    //            .padding()
    //            .frame(width: 595, height: 842) // PDF 크기 에이포 기준으로 했음 일단
    //
    //        // ImageRenderer에 SwiftUI Markdown 뷰를 직접 전달하여 PDF 생성
    //        let renderer = ImageRenderer(content: markdownView)
    //        let url = FileManager.default.temporaryDirectory.appendingPathComponent("ReportSummary.pdf")
    //
    //        renderer.render { size, context in
    //            var box = CGRect(x: 0, y: 0, width: size.width, height: size.height)
    //            guard let pdfContext = CGContext(url as CFURL, mediaBox: &box, nil) else {
    //                print("PDF 생성 실패")
    //                return
    //            }
    //
    //            pdfContext.beginPDFPage(nil)
    //            context(pdfContext)
    //            pdfContext.endPDFPage()
    //            pdfContext.closePDF()
    //        }
    //
    //        // PDF 생성 확인
    //        if FileManager.default.fileExists(atPath: url.path) {
    //            self.pdfURL = url
    //            print("PDF 파일이 생성되었습니다: \(url)")
    //        } else {
    //            print("PDF 파일 생성에 실패했습니다.")
    //        }
    //    }
}
