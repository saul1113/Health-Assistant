
//  ReportHealthManager.swift
//  Health-Assistant
//
//  Created by wonhoKim on 11/5/24.
//

import Foundation
import HealthKit

//여기도 시간남을때 어싱크로 바꿀게요
class ReportHealthManager: ObservableObject{
    let healthStore = HKHealthStore()
    @Published var healthReports: [Date: [HealthReport]] = [:]
    // 권한 요청
    func requestAuthorization(completion: @escaping (Bool, Error?) -> Void) {
        guard HKHealthStore.isHealthDataAvailable() else {
            completion(false, nil)
            return
        }
        
        let readTypes: Set<HKObjectType> = [
            HKObjectType.quantityType(forIdentifier: .heartRate)!,
            HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!,
            HKObjectType.quantityType(forIdentifier: .oxygenSaturation)!,
            HKObjectType.quantityType(forIdentifier: .bodyTemperature)!
        ]
        
        healthStore.requestAuthorization(toShare: [], read: readTypes) { success, error in
            completion(success, error)
        }
    }
    
    // 각 건강데이터 평균값 가져오는 메소드 데이터가없을경우 0.0으로 고정
    func fetchAverageHeartRate(for date: Date, completion: @escaping (Double) -> Void) {
            guard let heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate) else {
                completion(0.0)
                return
            }

            let calendar = Calendar.current
            let startOfDay = calendar.startOfDay(for: date)
            let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)
            
            let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: endOfDay)
            let query = HKStatisticsQuery(quantityType: heartRateType, quantitySamplePredicate: predicate, options: .discreteAverage) { _, result, _ in
                guard let result = result, let averageHeartRate = result.averageQuantity()?.doubleValue(for: HKUnit.count().unitDivided(by: HKUnit.minute())) else {
                    completion(0.0)
                    return
                }
                completion(averageHeartRate)
            }
            healthStore.execute(query)
        }
        
        func fetchOxygenSaturation(for date: Date, completion: @escaping (Double) -> Void) {
            guard let oxygenSaturationType = HKObjectType.quantityType(forIdentifier: .oxygenSaturation) else {
                completion(0.0)
                return
            }

            let calendar = Calendar.current
            let startOfDay = calendar.startOfDay(for: date)
            let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)
            
            let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: endOfDay)
            let query = HKStatisticsQuery(quantityType: oxygenSaturationType, quantitySamplePredicate: predicate, options: .discreteAverage) { _, result, _ in
                guard let result = result, let averageOxygenSaturation = result.averageQuantity()?.doubleValue(for: HKUnit.percent()) else {
                    completion(0.0)
                    return
                }
                completion(averageOxygenSaturation * 100) // 퍼센트로 반환
            }
            healthStore.execute(query)
        }
    
    func fetchBodyTemperature(for date: Date, completion: @escaping (Double) -> Void) {
        guard let temperatureType = HKObjectType.quantityType(forIdentifier: .bodyTemperature) else {
            completion(0.0)
            return
        }
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)
        
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: endOfDay)
        let query = HKStatisticsQuery(quantityType: temperatureType, quantitySamplePredicate: predicate, options: .discreteAverage) { _, result, _ in
            guard let result = result, let averageTemperature = result.averageQuantity()?.doubleValue(for: HKUnit.degreeCelsius()) else {
                completion(0.0)
                return
            }
            completion(averageTemperature)
        }
        healthStore.execute(query)
    }
    func fetchBreathRate(for date: Date, completion: @escaping (Double) -> Void) {
        guard let breathRateType = HKObjectType.quantityType(forIdentifier: .respiratoryRate) else {
            completion(0.0)
            return
        }
        
        // 해당 날짜의 시작과 끝 시간을 설정
        let startOfDay = Calendar.current.startOfDay(for: date)
        let endOfDay = Calendar.current.date(byAdding: .day, value: 1, to: startOfDay)?.addingTimeInterval(-1)
        
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: endOfDay)
        let query = HKStatisticsQuery(quantityType: breathRateType, quantitySamplePredicate: predicate, options: .discreteAverage) { _, result, _ in
            guard let result = result, let averageBreathRate = result.averageQuantity()?.doubleValue(for: HKUnit.count().unitDivided(by: HKUnit.minute())) else {
                completion(0.0)
                return
            }
            completion(averageBreathRate)
        }
        healthStore.execute(query)
    }

    func fetchSleepData(for date: Date, completion: @escaping (Double, Double, Double, Double, Double, Double) -> Void) {
        guard let sleepType = HKObjectType.categoryType(forIdentifier: .sleepAnalysis) else {
            completion(0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
            return
        }
        
        // 해당 날짜의 시작과 끝 시간을 설정
        let startOfDay = Calendar.current.startOfDay(for: date)
        let endOfDay = Calendar.current.date(byAdding: .day, value: 1, to: startOfDay)?.addingTimeInterval(-1)
        
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: endOfDay)
        let query = HKSampleQuery(sampleType: sleepType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { _, results, _ in
            var inBedMinute = 0.0
            var asleepUnspecifiedMinute = 0.0
            var awakeMinute = 0.0
            var asleepCoreMinute = 0.0
            var asleepDeepMinute = 0.0
            var asleepREMMinute = 0.0
            
            results?.forEach { sample in
                if let sleepSample = sample as? HKCategorySample {
                    let duration = sleepSample.endDate.timeIntervalSince(sleepSample.startDate)
                    switch sleepSample.value {
                    case HKCategoryValueSleepAnalysis.inBed.rawValue:
                        inBedMinute += duration
                    case HKCategoryValueSleepAnalysis.asleepUnspecified.rawValue:
                        asleepUnspecifiedMinute += duration
                    case HKCategoryValueSleepAnalysis.awake.rawValue:
                        awakeMinute += duration
                    case HKCategoryValueSleepAnalysis.asleepCore.rawValue:
                        asleepCoreMinute += duration
                    case HKCategoryValueSleepAnalysis.asleepDeep.rawValue:
                        asleepDeepMinute += duration
                    case HKCategoryValueSleepAnalysis.asleepREM.rawValue:
                        asleepREMMinute += duration
                    default:
                        break
                    }
                }
            }
            
            completion(inBedMinute, asleepUnspecifiedMinute, awakeMinute, asleepCoreMinute, asleepDeepMinute, asleepREMMinute)
        }
        
        healthStore.execute(query)
    }

    func fetchSleepDataForMultipleDays(startDate: Date, endDate: Date, completion: @escaping ([(Double, Double, Double, Double, Double)]) -> Void) {
        guard let sleepType = HKObjectType.categoryType(forIdentifier: .sleepAnalysis) else {
            completion([])
            return
        }
        
        var sleepData: [(Double, Double, Double, Double, Double)] = [] // 코어수면, 깊은수면, 램수면, 불명수면, 깨어있는 시간
        
        let calendar = Calendar.current
        var currentStartDate = calendar.startOfDay(for: startDate)
        var currentEndDate = calendar.date(byAdding: .day, value: 1, to: currentStartDate)!
        
        while currentEndDate <= endDate {
            let predicate = HKQuery.predicateForSamples(withStart: currentStartDate, end: currentEndDate)
            
            let query = HKSampleQuery(sampleType: sleepType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { _, results, _ in
                var asleepCoreMinute = 0.0
                var asleepDeepMinute = 0.0
                var asleepREMMinute = 0.0
                var asleepUnspecifiedMinute = 0.0
                var awakeMinute = 0.0
                
                results?.forEach { sample in
                    if let sleepSample = sample as? HKCategorySample {
                        let duration = sleepSample.endDate.timeIntervalSince(sleepSample.startDate) / 60 // 분 단위로 변환
                        switch sleepSample.value {
                        case HKCategoryValueSleepAnalysis.asleepCore.rawValue:
                            asleepCoreMinute += duration
                        case HKCategoryValueSleepAnalysis.asleepDeep.rawValue:
                            asleepDeepMinute += duration
                        case HKCategoryValueSleepAnalysis.asleepREM.rawValue:
                            asleepREMMinute += duration
                        case HKCategoryValueSleepAnalysis.asleepUnspecified.rawValue:
                            asleepUnspecifiedMinute += duration
                        case HKCategoryValueSleepAnalysis.awake.rawValue:
                            awakeMinute += duration
                        default:
                            break
                        }
                    }
                }
                
                // 각 날짜에 대한 수면 데이터 추가 (날짜는 제외하고 상태만 저장)
                sleepData.append((asleepCoreMinute, asleepDeepMinute, asleepREMMinute, asleepUnspecifiedMinute, awakeMinute))
                
                // 모든 날짜에 대해 데이터를 가져온 후 completion 호출
                if currentEndDate >= endDate {
                    completion(sleepData)
                }
            }
            
            healthStore.execute(query)
            
            // 다음 날짜로 넘어감
            currentStartDate = currentEndDate
            currentEndDate = calendar.date(byAdding: .day, value: 1, to: currentStartDate)!
        }
    }


    
}
