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
        VStack(alignment: .leading) {
            Text("수면 데이터")
                .font(.title2)
                .padding(.horizontal)
            
            Chart(viewModel.sleepData) { stage in
                RectangleMark(
                    xStart: .value("Start Time", stage.startDate),
                    xEnd: .value("End Time", stage.endDate),
                    y: .value("Stage", stage.stage.description)
                )
                .foregroundStyle(sleepStageColor(stage.stage)) // 수면 단계에 따른 색상 설정
            }
            .chartYAxis {
                AxisMarks(position: .leading) {
                    AxisValueLabel()
                }
            }
            .chartLegend(.hidden)
            .frame(height: 300)
            .padding()
        }
    }
    
    // 수면 단계에 따른 색상 설정 함수
    private func sleepStageColor(_ stage: SleepStage) -> Color {
        switch stage {
        case .awake: return .orange
        case .rem: return .blue.opacity(0.5)
        case .core: return .blue
        case .deep: return .indigo
        }
    }
}
