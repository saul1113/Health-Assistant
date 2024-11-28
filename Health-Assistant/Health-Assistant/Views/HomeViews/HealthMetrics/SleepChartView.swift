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
        NavigationStack {
            VStack {
                // 세그먼트 필터 추가
                Picker("기간 선택", selection: $viewModel.selectedFilter) {
                    Text("1일").tag(SleepFilter.oneDay)
                    Text("1주").tag(SleepFilter.oneWeek)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
                
                ScrollView {
                    if viewModel.selectedFilter == .oneDay {
                        dayViewChart()
                    } else {
                        weekViewChart()
                    }
                    
                    HStack {
                        Text("수면 기록")
                            .font(.semibold22)
                        Spacer()
                    }
                    .padding(.horizontal)
                    
                    // 수면 단계별 총 시간 표시
                    VStack {
                        HStack {
                            Text("비수면 총 시간:")
                                .font(.regular20)
                            
                            Spacer()
                            
                            Text("\(formatDuration(viewModel.totalTime(for: .awake)))")
                                .font(.regular20)
                        }
                        HStack {
                            Text("REM 수면 총 시간:")
                                .font(.regular20)
                            
                            Spacer()
                            
                            Text("\(formatDuration(viewModel.totalTime(for: .rem)))")
                                .font(.regular20)
                        }
                        HStack {
                            Text("코어 수면 총 시간:")
                                .font(.regular20)
                            
                            Spacer()
                            
                            Text("\(formatDuration(viewModel.totalTime(for: .core)))")
                                .font(.regular20)
                        }
                        HStack {
                            Text("깊은 수면 총 시간:")
                                .font(.regular20)
                            
                            Spacer()
                            
                            Text("\(formatDuration(viewModel.totalTime(for: .deep)))")
                                .font(.regular20)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                    
                    // 수면 데이터를 VStack과 ForEach로 표시
                    ForEach(viewModel.filteredSleepData()) { stage in
                        VStack(alignment: .leading, spacing: 5) {
                            HStack {
                                Text("수면 단계:  \(stage.stage.rawValue)")
                                    .font(.semibold18)
                                
                                Spacer()
                                
                                Text("\(formatTimeRange(start: stage.startDate, end: stage.endDate))")
                                    .font(.regular16)
                            }
                            
                            Divider()
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .navigationTitle("수면 데이터")
            .font(.bold20)
        }
    }
    
    private func dayViewChart() -> some View {
        VStack(alignment: .leading) {
            // 수면 시간과 날짜 표시
            if let firstSleep = viewModel.sleepData.first {
                let totalSleepDuration = viewModel.calculateTotalSleepDuration()
                
                Text("수면 시간")
                    .font(.semibold20)
                    .padding(.horizontal)
                
                Text("\(formatDuration(totalSleepDuration))")
                    .font(.bold30)
                    .padding(.horizontal)
                    .padding(.bottom, 2)
                
                Text(formatDateToYearMonthDay(Date()))
                    .font(.regular16)
                    .foregroundColor(.gray)
                    .padding(.horizontal)
                    .padding(.bottom, 10)
            }
            
            Chart {
                ForEach(viewModel.filteredSleepData().indices, id: \.self) { index in
                    let stage = viewModel.filteredSleepData()[index]
                    
                    // 수면 단계의 색상을 stage.color로 설정
                    RectangleMark(
                        xStart: .value("Start Time", stage.startDate),
                        xEnd: .value("End Time", stage.endDate),
                        y: .value("Stage", stage.stage.rawValue)
                    )
                    .foregroundStyle(stage.stage.color)
                    
                    // 다음 단계와 현재 단계의 끝을 선으로 연결
                    if index < viewModel.filteredSleepData().count - 1 {
                        let nextStage = viewModel.filteredSleepData()[index + 1]
                        
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
    }
    
    private func weekViewChart() -> some View {
        VStack(alignment: .leading) {
            let averageSleepDuration = viewModel.calculateAverageSleepDuration()
            let dateRangeText = calculateDateRange()
            
            Text("평균 수면 시간")
                .font(.semibold20)
                .padding(.horizontal)
            
            Text("\(formatDuration(averageSleepDuration))")
                .font(.bold30)
                .padding(.horizontal)
                .padding(.bottom, 2)
            
            Text(dateRangeText)
                .font(.regular16)
                .foregroundColor(.gray)
                .padding(.horizontal)
                .padding(.bottom, 10)
            
            Chart {
                ForEach(viewModel.filteredSleepData(), id: \.id) { stage in
                    let dayOffset = daysFromToday(stage.startDate)
                    let startTimeInHours = hours(from: stage.startDate)
                    let endTimeInHours = hours(from: stage.endDate)
                    
                    RectangleMark(
                        x: .value("요일", 6 - dayOffset),
                        yStart: .value("Start Time", startTimeInHours),
                        yEnd: .value("End Time", endTimeInHours)
                    )
                    .foregroundStyle(stage.stage.color)
                }
            }
            .chartXScale(domain: 1...7) // 오늘을 0으로 두고 6일 전을 -6으로 설정
            .chartXAxis {
                AxisMarks(values: .stride(by: 1)) { value in
                    AxisGridLine()
                    AxisTick()
                    AxisValueLabel {
                        if let intValue = value.as(Int.self) {
                            // 실제 날짜를 계산하여 dayOfWeekString에 전달
                            let date = Calendar.current.date(byAdding: .day, value: intValue - 6, to: Date())!
                            Text(dayOfWeekString(for: date))
                        }
                    }
                }
            }
            .chartYAxis {
                AxisMarks(values: .stride(by: 1)) { value in
                    AxisGridLine()
                    AxisTick()
                    AxisValueLabel {
                        if let hour = value.as(Double.self) {
                            Text(hourString(from: hour))
                        }
                    }
                }
            }
            .frame(height: 300)
            .padding()
        }
    }
    
    // 오늘부터의 일 수 차이로 요일을 계산하는 함수
    private func daysFromToday(_ date: Date) -> Int {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let targetDate = calendar.startOfDay(for: date)
        
        return calendar.dateComponents([.day], from: targetDate, to: today).day ?? 0
    }
    
    private func formatTimeRange(start: Date, end: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        return "\(formatter.string(from: start)) ~ \(formatter.string(from: end))"
    }
    
    private func formatDateToYearMonthDay(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 M월 d일"
        return formatter.string(from: date)
    }
    
    private func formatDuration(_ duration: TimeInterval) -> String {
        let hours = Int(duration) / 3600
        let minutes = (Int(duration) % 3600) / 60
        return "\(hours)시간 \(minutes)분"
    }
    
    private func calculateDateRange() -> String {
        let calendar = Calendar.current
        let today = Date()
        guard let startDate = calendar.date(byAdding: .day, value: -6, to: today) else { return "" }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 M월 d일"
        
        return "\(formatter.string(from: startDate)) ~ \(formatter.string(from: today))"
    }
    
    private func hours(from date: Date) -> Double {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minute = calendar.component(.minute, from: date)
        return Double(hour) + Double(minute) / 60.0
    }
    
    // 날짜에 맞는 요일을 반환하는 함수
    private func dayOfWeekString(for date: Date) -> String {
        let calendar = Calendar.current
        let day = calendar.component(.weekday, from: date)
        
        switch day {
        case 1: return "일"
        case 2: return "월"
        case 3: return "화"
        case 4: return "수"
        case 5: return "목"
        case 6: return "금"
        case 7: return "토"
        default: return ""
        }
    }
    
    private func hourString(from hour: Double) -> String {
        let intHour = Int(hour)
        let minute = Int((hour - Double(intHour)) * 60)
        return String(format: "%02d:%02d", intHour, minute)
    }
}
