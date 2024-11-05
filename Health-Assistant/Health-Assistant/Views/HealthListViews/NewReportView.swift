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
    @State private var healthData: [HealthReport] = []
    @ObservedObject var healthDataManager: HealthDataManager
    var onSave: (HealthReportSummary) -> Void
    
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
                        fetchHealthData()
                        dismiss()
                    }
                }
            }
        }
    }
    //이거 옛날 방식인거 같은데 시간남으면 async로 바꿀게요
    private func fetchHealthData() {
         let calendar = Calendar.current
         var currentDate = startDate
         let group = DispatchGroup()
         var reports: [HealthReport] = []

         while currentDate <= endDate {
             let date = currentDate
             
             group.enter()
             healthDataManager.fetchAverageHeartRate(for: date) { heartRate in
                 group.enter()
                 healthDataManager.fetchBodyTemperature(for: date) { temperature in
                     group.enter()
                     healthDataManager.fetchOxygenSaturation(for: date) { oxygenSaturation in
                         group.enter()
                         healthDataManager.fetchBreathRate(for: date) { breath in
                             let report = HealthReport(
                                 id: UUID(),
                                 title: title, // 리포트의 타이틀 추가
                                 date: date,
                                 heartRate: Double(heartRate),
                                 temperature: temperature,
                                 breath: Int(breath),
                                 oxygenSaturation: oxygenSaturation
                             )
                             
                             reports.append(report)
                             group.leave()
                         }
                         group.leave()
                     }
                     group.leave()
                 }
                 group.leave()
             }
             
             currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!
         }
         
         // 모든 디스패치 그룹의 작업이 끝나면 실행
         group.notify(queue: .main) {
             let newSummary = HealthReportSummary(id: UUID(), title: title, startDate: startDate, endDate: endDate, healthReports: reports)
             onSave(newSummary)
         }
     }
 }
