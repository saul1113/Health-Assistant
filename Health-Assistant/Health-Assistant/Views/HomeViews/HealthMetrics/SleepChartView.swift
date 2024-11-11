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
            
            Chart {
                ForEach(viewModel.sleepData.indices, id: \.self) { index in
                    let stage = viewModel.sleepData[index]
                    
                    // 현재 수면 상태를 막대로 표시
                    RectangleMark(
                        xStart: .value("Start Time", stage.startDate),
                        xEnd: .value("End Time", stage.endDate),
                        y: .value("Stage", stage.stage.description)
                    )
                    .foregroundStyle(sleepStageColor(stage.stage))
                    
                    // 다음 수면 상태와 이어주는 선을 추가
                    if index < viewModel.sleepData.count - 1 {
                        let nextStage = viewModel.sleepData[index + 1]
                        LineMark(
                            x: .value("End Time", stage.endDate),
                            y: .value("Current Stage", stage.stage.description)
                        )
                        .lineStyle(StrokeStyle(lineWidth: 2, dash: [5])) // 선 스타일 설정
                        .foregroundStyle(Color.gray)
                        
                        LineMark(
                            x: .value("Start Time", nextStage.startDate),
                            y: .value("Next Stage", nextStage.stage.description)
                        )
                        .lineStyle(StrokeStyle(lineWidth: 2, dash: [5])) // 선 스타일 설정
                        .foregroundStyle(Color.gray)
                    }
                }
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
