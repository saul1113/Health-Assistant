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
            
            
            // 심박수 데이터 리스트 표시
            Text("심박수 기록")
                .font(.bold20)
                .padding(.horizontal)
            
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
                    .padding(.horizontal)
                    Divider() // 각 항목 사이에 구분선 추가
                }
            }
            .padding(.horizontal)
            
            Spacer(minLength: 50)
        }
    }
    private func xAxisDateFormat() -> Date.FormatStyle {
        switch viewModel.selectedTimeRange {
        case .sixHours, .oneDay:
            return .dateTime.hour().minute() // 시간 형식
        case .oneWeek, .oneMonth:
            return .dateTime.month().day().locale(Locale(identifier: "ko_KR")) // 날짜 형식
        }
    }
}

extension HeartRateViewModel {
    func getAveragedData(for range: TimeRange) -> [HeartRateModel] {
        let interval: TimeInterval
        switch range {
        case .sixHours:
            interval = 3600 // 1시간
        case .oneDay:
            interval = 14400 // 4시간
        case .oneWeek:
            interval = 86400 // 1일
        case .oneMonth:
            interval = 345600 // 4일
        }
        
        // 그룹화하여 평균값 계산
        let groupedData = Dictionary(grouping: filteredData) { sample in
            Date(timeIntervalSinceReferenceDate: (sample.date.timeIntervalSinceReferenceDate / interval).rounded(.down) * interval)
        }
        
        var averagedData = groupedData.map { date, samples in
            let averageValue = samples.map(\.value).reduce(0, +) / Double(samples.count)
            return HeartRateModel(date: date, value: averageValue)
        }
            .sorted { $0.date < $1.date }
        
        // 현재 시간까지 마지막 구간을 추가하여 선 그래프가 이어지도록 설정
        if let lastDate = averagedData.last?.date, lastDate < Date() {
            let lastValue = averagedData.last?.value ?? 0
            averagedData.append(HeartRateModel(date: Date(), value: lastValue))
        }
        
        return averagedData
    }
}
