//
//  SleepChartView.swift
//  Health-Assistant
//
//  Created by Hwang_Inyoung on 11/11/24.
//

import SwiftUI
import Charts

struct SleepChartView: View {
    @StateObject private var viewModel = SleepDataViewModel()
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                // 수면 시간과 날짜 표시
                if let firstSleep = viewModel.sleepData.first {
                    let totalSleepDuration = calculateTotalSleepDuration()
                    
                    Text("수면 시간")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    Text("\(formatDuration(totalSleepDuration))")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.horizontal)
                        .padding(.bottom, 2)
                    
                    Text(formatDateToYearMonthDay(firstSleep.startDate))
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .padding(.horizontal)
                        .padding(.bottom, 10)
                }
                
                Text("수면 데이터")
                    .font(.title2)
                    .padding(.horizontal)
                
                Chart {
                    ForEach(viewModel.sleepData.indices, id: \.self) { index in
                        let stage = viewModel.sleepData[index]
                        
                        // 수면 단계의 색상을 stage.color로 설정
                        RectangleMark(
                            xStart: .value("Start Time", stage.startDate),
                            xEnd: .value("End Time", stage.endDate),
                            y: .value("Stage", stage.stage.rawValue)
                        )
                        .foregroundStyle(stage.stage.color)
                        
                        // 다음 단계와 현재 단계의 끝을 선으로 연결
                        if index < viewModel.sleepData.count - 1 {
                            let nextStage = viewModel.sleepData[index + 1]
                            
                            // 선으로 연결하는 LineMark 추가
                            LineMark(
                                x: .value("End Time", stage.endDate),
                                y: .value("Current Stage", stage.stage.rawValue)
                            )
                            .foregroundStyle(Color.gray)
                            
                            LineMark(
                                x: .value("Start Time", nextStage.startDate),
                                y: .value("Next Stage", nextStage.stage.rawValue)
                            )
                            .foregroundStyle(Color.gray)
                        }
                    }
                }
                .chartYAxis {
                    AxisMarks {
                        AxisValueLabel()
                    }
                }
                .chartLegend(.hidden)
                .frame(height: 300)
                .padding()
            }
            
            // 수면 데이터를 VStack과 ForEach로 표시
            ForEach(viewModel.sleepData) { stage in
                VStack(alignment: .leading, spacing: 5) {
                    Text("수면 단계: \(stage.stage.rawValue)")
                        .font(.headline)
                    Text("시작 시간: \(formatDate(stage.startDate))")
                    Text("종료 시간: \(formatDate(stage.endDate))")
                }
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 1)
                .padding(.horizontal)
            }
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    private func formatDateToYearMonthDay(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 M월 d일"
        return formatter.string(from: date)
    }
    
    // 수면 단계 총 시간을 계산하는 함수
    private func calculateTotalSleepDuration() -> TimeInterval {
        viewModel.sleepData.reduce(0) { total, stage in
            total + stage.endDate.timeIntervalSince(stage.startDate)
        }
    }
    
    // TimeInterval을 읽기 쉬운 형식으로 포맷
    private func formatDuration(_ duration: TimeInterval) -> String {
        let hours = Int(duration) / 3600
        let minutes = (Int(duration) % 3600) / 60
        return "\(hours)시간 \(minutes)분"
    }
}
