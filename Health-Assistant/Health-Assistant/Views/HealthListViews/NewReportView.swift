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
    @State private var startDate: Date = Calendar.current.date(byAdding: .month, value: -1, to: Date()) ?? Date()
    @State private var endDate: Date = Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date()
    @State private var healthData: [HealthReport] = []
    @ObservedObject var reportHealthManager: ReportHealthManager
    var onSave: (HealthReportSummary) -> Void
    
    
    var body: some View {
        
        NavigationView {
            Form {
                //한달로제한
                Section(header: Text("평균 건강 데이터 리포트 생성")) {
                    TextField("리포트 제목", text: $title)
                    DatePicker(
                        "Start Date",
                        selection: $startDate,
                        in: ...Date(),
                        displayedComponents: .date
                    )
                   
                    DatePicker(
                        "End Date",
                        selection: $endDate,
                        in: startDate...(min(Calendar.current.date(byAdding: .month, value: 1, to: startDate) ?? Date(), Date())),
                        displayedComponents: .date
                    )
                }
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
    
    
    private func fetchHealthData() {
        let calendar = Calendar.current
        var currentDate = startDate
        let group = DispatchGroup()
        var reports: [HealthReport] = []
        
        while currentDate <= endDate {
            let date = currentDate
            
            group.enter()
            reportHealthManager.fetchAverageHeartRate(for: date) { heartRate in
                group.enter()
                reportHealthManager.fetchBodyTemperature(for: date) { temperature in
                    group.enter()
                    reportHealthManager.fetchOxygenSaturation(for: date) { oxygenSaturation in
                        group.enter()
                        reportHealthManager.fetchBreathRate(for: date) { breath in
                            group.enter()
                            reportHealthManager.fetchSleepData(for: date) { inBedMinute, asleepUnspecifiedMinute, awakeMinute, asleepCoreMinute, asleepDeepMinute, asleepREMMinute in
                                
                                
                                let report = HealthReport(
                                    id: UUID(),
                                    title: title, // 리포트의 타이틀 추가
                                    date: date,
                                    heartRate: Double(heartRate),
                                    temperature: temperature,
                                    breath: Int(breath),
                                    oxygenSaturation: oxygenSaturation,
                                    inBedMinute: inBedMinute,
                                    asleepUnspecifiedMinute: asleepUnspecifiedMinute,
                                    awakeMinute: awakeMinute,
                                    asleepCoreMinute: asleepCoreMinute,
                                    asleepDeepMinute: asleepDeepMinute,
                                    asleepREMMinute: asleepREMMinute
                                )
                                print(date)
                                reports.append(report)
                                group.leave()
                            }
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
