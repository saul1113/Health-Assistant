//
//  NewReportView.swift
//  Health-Assistant
//
//  Created by wonhoKim on 11/4/24.
//

import SwiftUI

struct NewReportView: View {
    @Environment(\.dismiss) var dismiss
    @State private var title: String = ""
    @State private var startDate = Date()
    @State private var endDate = Date()
    
    var onSave: (HealthReport) -> Void
    
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
                        let newReport = HealthReport(id: UUID().hashValue, title: title, startDate: startDate, endDate: endDate)
                        onSave(newReport)
                        dismiss()
                    }
                }
            }
        }
    }
}
