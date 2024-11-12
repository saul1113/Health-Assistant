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
                        .foregroundStyle(stage.stage.color) // stage.color 사용
                        
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
    
}
