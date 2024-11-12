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
                // 수면 단계를 원하는 순서로 정렬하여 sleepData에 저장
                self?.sleepData = sleepData.sorted { $0.startDate < $1.startDate }
            }
        }
    }
}
