//
//  SleepDataViewModel.swift
//  Health-Assistant
//
//  Created by Hwang_Inyoung on 11/11/24.
//

import Foundation
import HealthKit

class SleepDataViewModel: ObservableObject {
    @Published var sleepData: [SleepStageModel] = []
    @Published var selectedFilter: SleepFilter = .oneDay // 필터 상태를 추가하여 뷰에서 변경 가능하도록 설정
    private var healthDataManager = HealthDataManager.shared
    
    init() {
        fetchSleepData()
    }
    
    func fetchSleepData() {
        healthDataManager.fetchSleepData { [weak self] samples, error in
            guard let samples = samples else { return }
            
            var sleepData: [SleepStageModel] = []
            
            samples.forEach { sample in
                let stage: SleepStage
                
                switch sample.value {
                case HKCategoryValueSleepAnalysis.awake.rawValue:
                    stage = .awake
                case HKCategoryValueSleepAnalysis.asleepREM.rawValue:
                    stage = .rem
                case HKCategoryValueSleepAnalysis.asleepCore.rawValue:
                    stage = .core
                case HKCategoryValueSleepAnalysis.asleepDeep.rawValue:
                    stage = .deep
                default:
                    return
                }
                
                sleepData.append(
                    SleepStageModel(
                        startDate: sample.startDate,
                        endDate: sample.endDate,
                        stage: stage
                    )
                )
            }
            
            DispatchQueue.main.async {
                self?.sleepData = sleepData.sorted { $0.startDate < $1.startDate }
            }
        }
    }
    
    // 필터된 데이터를 반환하는 함수
    func filteredSleepData() -> [SleepStageModel] {
        let calendar = Calendar.current
        let now = Date()
        
        switch selectedFilter {
        case .oneDay:
            return sleepData.filter {
                calendar.isDate($0.startDate, inSameDayAs: now)
            }
        case .oneWeek:
            guard let weekAgo = calendar.date(byAdding: .day, value: -6, to: now) else {
                return sleepData
            }
            return sleepData.filter {
                $0.startDate >= weekAgo && $0.startDate <= now
            }
        }
    }
    
    // 특정 수면 단계의 총 시간을 계산하는 함수
    func totalTime(for stageType: SleepStage) -> TimeInterval {
        filteredSleepData()
            .filter { $0.stage == stageType }
            .reduce(0) { total, stage in
                total + stage.endDate.timeIntervalSince(stage.startDate)
            }
    }
    
    // 수면 단계 총 시간을 계산하는 함수
    func calculateTotalSleepDuration() -> TimeInterval {
        filteredSleepData().reduce(0) { total, stage in
            total + stage.endDate.timeIntervalSince(stage.startDate)
        }
    }
    
    // 주간 평균 수면 시간을 계산하는 함수
    func calculateAverageSleepDuration() -> TimeInterval {
        let totalDuration = calculateTotalSleepDuration()
        let days = Set(filteredSleepData().map { Calendar.current.startOfDay(for: $0.startDate) }).count
        return days > 0 ? totalDuration / Double(days) : 0
    }
}

enum SleepFilter {
    case oneDay
    case oneWeek
}
