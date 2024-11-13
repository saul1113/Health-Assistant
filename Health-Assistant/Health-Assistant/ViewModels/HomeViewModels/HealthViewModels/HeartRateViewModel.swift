//
//  HeartRateViewModel.swift
//  Health-Assistant
//
//  Created by Hwang_Inyoung on 11/10/24.
//

import SwiftUI
import HealthKit

enum TimeRange {
    case sixHours, oneDay, oneWeek
}

class HeartRateViewModel: ObservableObject {
    @Published var heartRateData: [HeartRateModel] = []
    @Published var filteredData: [HeartRateModel] = []
    private var healthDataManager = HealthDataManager.shared
    private var allData: [HeartRateModel] = []
    
    @Published var selectedTimeRange: TimeRange = .sixHours {
        didSet {
            filterData()
        }
    }
    
    init() {
        fetchOneMonthHeartRateData()
    }
    
    func fetchOneMonthHeartRateData() {
        healthDataManager.fetchOneMonthHeartRateData { [weak self] samples, error in
            guard let samples = samples else { return }
            
            let heartRateData = samples.map { sample in
                let value = sample.quantity.doubleValue(for: HKUnit(from: "count/min"))
                return HeartRateModel(date: sample.startDate, value: value)
            }
            
            DispatchQueue.main.async {
                self?.allData = heartRateData
                self?.filterData()
            }
        }
    }
    
    private func filterData() {
        let now = Date()
        let startDate: Date
        
        switch selectedTimeRange {
        case .sixHours:
            startDate = Calendar.current.date(byAdding: .hour, value: -6, to: now)!
        case .oneDay:
            startDate = Calendar.current.date(byAdding: .day, value: -1, to: now)!
        case .oneWeek:
            startDate = Calendar.current.date(byAdding: .day, value: -7, to: now)!
        }
        
        filteredData = allData.filter { $0.date >= startDate }
    }
    
    // 최소 및 최대 심박수 계산
    var minHeartRate: Double? {
        filteredData.min(by: { $0.value < $1.value })?.value
    }
    
    var maxHeartRate: Double? {
        filteredData.max(by: { $0.value < $1.value })?.value
    }
    
    // 선택된 기간 표시
    var timeRangeText: String {
        guard let start = filteredData.first?.date, let end = filteredData.last?.date else {
            return ""
        }
        
        let formatter = DateFormatter()
        
        switch selectedTimeRange {
        case .sixHours:
            formatter.dateFormat = "HH:mm"
            return "\(formatter.string(from: start))부터 ~ \(formatter.string(from: end))까지"
        case .oneDay:
            return "오늘"
        case .oneWeek:
            formatter.dateFormat = "MM월 dd일"
            return "\(formatter.string(from: start))부터 ~ \(formatter.string(from: end))까지"
        }
    }
    
    func formattedDate(for date: Date) -> String {
        let formatter = DateFormatter()
        if selectedTimeRange == .sixHours {
            formatter.dateFormat = "HH:mm"
        } else {
            formatter.dateFormat = "MM월 dd일 HH:mm"
        }
        return formatter.string(from: date)
    }
    
    func getAveragedData(for range: TimeRange) -> [HeartRateModel] {
        let interval: TimeInterval
        switch range {
        case .sixHours:
            interval = 3600 // 1시간
        case .oneDay:
            interval = 14400 // 4시간
        case .oneWeek:
            interval = 86400 // 1일
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

extension HealthDataManager {
    func fetchOneMonthHeartRateData(completion: @escaping ([HKQuantitySample]?, Error?) -> Void) {
        guard let heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate) else {
            completion(nil, nil)
            return
        }
        
        let startDate = Calendar.current.date(byAdding: .month, value: -1, to: Date()) // 한 달 전부터 현재까지의 데이터
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: Date(), options: .strictStartDate)
        
        let query = HKSampleQuery(sampleType: heartRateType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { query, results, error in
            guard let samples = results as? [HKQuantitySample] else {
                completion(nil, error)
                return
            }
            completion(samples, nil)
        }
        
        healthStore.execute(query)
    }
}
