//
//  ReportHealthManager.swift
//  Health-Assistant
//
//  Created by wonhoKim on 11/5/24.
//

import Foundation
import HealthKit

class HealthDataManager: ObservableObject{
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
        let predicate = HKQuery.predicateForSamples(withStart: date, end: Calendar.current.date(byAdding: .day, value: 1, to: date))
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
        let predicate = HKQuery.predicateForSamples(withStart: date, end: Calendar.current.date(byAdding: .day, value: 1, to: date))
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
        let predicate = HKQuery.predicateForSamples(withStart: date, end: Calendar.current.date(byAdding: .day, value: 1, to: date))
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
        let predicate = HKQuery.predicateForSamples(withStart: date, end: Calendar.current.date(byAdding: .day, value: 1, to: date))
        let query = HKStatisticsQuery(quantityType: breathRateType, quantitySamplePredicate: predicate, options: .discreteAverage) { _, result, _ in
            guard let result = result, let averageBreathRate = result.averageQuantity()?.doubleValue(for: HKUnit.count().unitDivided(by: HKUnit.minute())) else {
                completion(0.0)
                return
            }
            completion(averageBreathRate)
        }
        healthStore.execute(query)
    }
}







