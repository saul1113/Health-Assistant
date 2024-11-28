
//  NewReportView.swift
//  Health-Assistant
//
//  Created by wonhoKim on 11/4/24.
//


import SwiftUI
import MarkdownUI

struct ReportsDetailView: View {
    var reportSummary: HealthReportSummary
    @StateObject private var pdfViewModel = PDFViewModel()
    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading) {
                    Markdown(pdfViewModel.generateMarkdown(from: reportSummary))
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
            .padding()
        }
        
    }
}
