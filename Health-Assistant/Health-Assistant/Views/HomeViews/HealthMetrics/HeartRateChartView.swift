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
        NavigationView {
            VStack(alignment: .leading) {
                // 세그먼트 필터
                Picker("시간 범위 선택", selection: $viewModel.selectedTimeRange) {
                    Text("6시간").tag(TimeRange.sixHours)
                    Text("1일").tag(TimeRange.oneDay)
                    Text("1주").tag(TimeRange.oneWeek)
                }
                .pickerStyle(SegmentedPickerStyle())
                .font(.semibold16) // 커스텀 폰트 사용
                .padding()
                
                ScrollView() {
                    
                    
                    VStack(alignment: .leading) {
                        HStack {
                            // 선택한 데이터 정보 표시
                            if let selectedData = selectedData {
                                VStack {
                                    HStack {
                                        Text("선택한 값: \(Int(selectedData.value)) BPM")
                                            .font(.regular20)
                                            .padding(.top, 8)
                                        
                                        Spacer()
                                    }
                                    
                                    HStack {
                                        Text("\(viewModel.formattedDate(for: selectedData.date))")
                                            .font(.regular20)
                                        
                                        Spacer()
                                    }
                                }
                            }
                            
                            if selectedData == nil, let minRate = viewModel.minHeartRate, let maxRate = viewModel.maxHeartRate {
                                Text("범위: \(Int(minRate)) BPM ~ \(Int(maxRate)) BPM")
                                    .font(.regular20)
                                    .padding(.top, 8)
                            }
                            Spacer()
                        }
                        
                        
                        HStack {
                            Text(viewModel.timeRangeText)
                                .font(.regular12)
                                .foregroundColor(.gray)
                                .padding(.bottom, 8)
                            
                            Spacer()
                        }
                        
                    }
                    .padding(.horizontal)
                    
                    
                    
                    // 데이터가 없을 경우 메시지 표시
                    if viewModel.filteredData.isEmpty {
                        Text("데이터 없음")
                            .font(.headline)
                            .foregroundColor(.gray)
                            .padding()
                            .frame(height: 300)
                    } else {
                        // 데이터가 있는 경우 차트 표시
                        Chart {
                            // 필터에 따른 평균값 그룹화
                            let averagedData = viewModel.getAveragedData(for: viewModel.selectedTimeRange)
                            
                            // 평균값으로 선 그래프 그리기
                            ForEach(averagedData) { item in
                                LineMark(
                                    x: .value("Time", item.date),
                                    y: .value("Heart Rate", item.value)
                                )
                                .foregroundStyle(.customGreen) // LineMark 색상 설정
                                .lineStyle(StrokeStyle(lineWidth: 2)) // 선 두께 설정
                            }
                            
                            // 점 그래프 유지
                            ForEach(viewModel.filteredData) { item in
                                PointMark(
                                    x: .value("Time", item.date),
                                    y: .value("Heart Rate", item.value)
                                )
                                .foregroundStyle(.red) // PointMark 색상 설정
                                .symbolSize({
                                    if let selected = selectedData, selected == item {
                                        return 100 // 선택된 데이터인 경우 큰 크기로 표시
                                    } else {
                                        return 50 // 기본 크기
                                    }
                                }())
                            }
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
                                AxisValueLabel(format: xAxisDateFormat())
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
                    
                    
                    HStack {
                        // 심박수 데이터 리스트 표시
                        Text("심박수 기록")
                            .font(.bold20)
                            .padding(.horizontal)
                        
                        Spacer()
                    }
                    if viewModel.filteredData.isEmpty {
                        Text("데이터 없음")
                            .font(.headline)
                            .foregroundColor(.gray)
                            .padding()
                            .frame(height: 300)
                    } else {
                        VStack(alignment: .leading, spacing: 8) {
                            ForEach(viewModel.filteredData) { data in
                                HStack {
                                    Text(viewModel.formattedDate(for: data.date)) // 날짜 포맷 적용
                                        .font(.regular14)
                                    Spacer()
                                    Text("\(Int(data.value)) BPM")
                                        .font(.regular14)
                                        .foregroundColor(.blue)
                                }
                                .padding(.vertical, 4)
                                Divider() // 각 항목 사이에 구분선 추가
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    Spacer(minLength: 50)
                }
            }
        }
        .navigationTitle("심박수 데이터")
    }
    private func xAxisDateFormat() -> Date.FormatStyle {
        switch viewModel.selectedTimeRange {
        case .sixHours, .oneDay:
            return .dateTime.hour().minute() // 시간 형식
        case .oneWeek:
            return .dateTime.month().day().locale(Locale(identifier: "ko_KR")) // 날짜 형식
        }
    }
}
