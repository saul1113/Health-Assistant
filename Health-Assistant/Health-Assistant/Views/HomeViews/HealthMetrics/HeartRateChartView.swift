//
//  HealthHeartRateView.swift
//  Health-Assistant
//
//  Created by Hwang_Inyoung on 11/10/24.
//

import SwiftUI
import Charts

struct HeartRateChartView: View {
    @StateObject private var viewModel = HeartRateViewModel()
    @State private var selectedData: HeartRateModel?
    
    var body: some View {
        ScrollView {
            Text("심박수 데이터")
                .font(.bold20) // 커스텀 폰트 사용
            
            // 세그먼트 필터
            Picker("시간 범위 선택", selection: $viewModel.selectedTimeRange) {
                Text("6시간").tag(TimeRange.sixHours)
                Text("1일").tag(TimeRange.oneDay)
                Text("1주").tag(TimeRange.oneWeek)
                Text("1개월").tag(TimeRange.oneMonth)
            }
            .pickerStyle(SegmentedPickerStyle())
            .font(.semibold16) // 커스텀 폰트 사용
            .padding()
            
            // 선택한 데이터 정보 표시
            if let selectedData = selectedData {
                Text("선택한 값: \(Int(selectedData.value)) BPM, 시간: \(viewModel.formattedDate(for: selectedData.date))")
                    .font(.regular14)
                    .padding(.top, 8)
            }
            
            if selectedData == nil, let minRate = viewModel.minHeartRate, let maxRate = viewModel.maxHeartRate {
                Text("범위: \(Int(minRate)) BPM ~ \(Int(maxRate)) BPM")
                    .font(.regular14)
                    .padding(.top, 8)
            }
            
            Text(viewModel.timeRangeText)
                .font(.regular12)
                .foregroundColor(.gray)
                .padding(.bottom, 8)
            
            // 차트 표시
            Chart(viewModel.filteredData) { item in
                PointMark(
                    x: .value("Time", item.date),
                    y: .value("Heart Rate", item.value)
                )
                .foregroundStyle(.red) // PointMark 색상 빨강으로 설정
                .symbolSize({
                    if let selected = selectedData, selected == item {
                        return 100 // 선택된 데이터인 경우 큰 크기로 표시
                    } else {
                        return 50 // 기본 크기
                    }
                }())
            }
            .chartOverlay { proxy in
                GeometryReader { geometry in
                    Color.clear.contentShape(Rectangle())
                        .onTapGesture { location in
                            let xPosition = location.x - geometry[proxy.plotAreaFrame].origin.x
                            if let selectedXValue = proxy.value(atX: xPosition) as Date?,
                               let nearestData = viewModel.filteredData.min(by: { abs($0.date.timeIntervalSince(selectedXValue)) < abs($1.date.timeIntervalSince(selectedXValue)) }) {
                                selectedData = nearestData
                            }
                        }
                }
            }
            .chartXAxis {
                AxisMarks(position: .bottom) {
                    AxisValueLabel(format: .dateTime.hour().minute())
                    AxisGridLine()
                }
            }
            .chartYAxis {
                AxisMarks(position: .trailing) {
                    AxisValueLabel()
                    AxisGridLine()
                }
            }
            .frame(height: 300)
            .padding()
        }
    }
}
