//
//  HealthManager.swift
//  Health-Assistant
//
//  Created by Soom on 11/4/24.
//

import HealthKit
import SwiftUI


class HealthDataManager: ObservableObject {
    @Published var heartRate: Double = 0
    @Published var isMeasuring: Bool = true
    static let shared = HealthDataManager()
    var healthStore = HKHealthStore()
    var stepCount: Int = 0
    
    init() {
        requestAuthorization { auth, error in
            if auth {
                self.startHeartRateQuery { data , error in
                    if let data = data {
                        DispatchQueue.main.async {
                            self.heartRate = data
                        }
                    }
                }
            } else {
                print("Error: \(String(describing: error))")
            }
        }
    }
    
    func requestAuthorization(completion: @escaping (Bool, Error?) -> Void) {
        guard HKHealthStore.isHealthDataAvailable() else {
            completion(false, nil)
            return
        }
        
        let heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate)!
        let sleepAnalysisType = HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!
        
        let readTypes: Set<HKObjectType> = [heartRateType, sleepAnalysisType]
        
        healthStore.requestAuthorization(toShare: [], read: readTypes) { success, error in
            completion(success, error)
        }
    }
}
extension HealthDataManager {
    func fetchHeartRateData(completion: @escaping ([HKQuantitySample]?, Error?) -> Void) {
        guard let heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate) else {
            completion(nil, nil)
            return
        }
        
        let startDate = Calendar.current.date(byAdding: .day, value: -7, to: Date())
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
    func fetchSleepData(completion: @escaping ([HKCategorySample]?, Error?) -> Void) {
        guard let sleepType = HKObjectType.categoryType(forIdentifier: .sleepAnalysis) else {
            completion(nil, nil)
            return
        }
        
        let startDate = Calendar.current.date(byAdding: .day, value: -7, to: Date())
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: Date(), options: .strictStartDate)
        
        let query = HKSampleQuery(sampleType: sleepType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: []) { query, results, error in
            guard let samples = results as? [HKCategorySample] else {
                completion(nil, error)
                return
            }
            completion(samples, nil)
        }
        
        healthStore.execute(query)
    }
    func startHeartRateQuery(completion: @escaping (Double?, Error?) -> Void) {
        guard let heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate) else { return }
        
        let query = HKAnchoredObjectQuery(type: heartRateType, predicate: nil, anchor: nil, limit: HKObjectQueryNoLimit) { [self] query, samples, deletedObjects, newAnchor, error in
            if let samples = samples as? [HKQuantitySample], let lastRate = samples.last {
                DispatchQueue.main.async {
                    isMeasuring = false
                    let heartRateUnit = HKUnit(from: "count/min")
                    let heartRateValue = lastRate.quantity.doubleValue(for: heartRateUnit)
                    completion(heartRateValue, nil)
                }
            } else {
                completion(nil, error)
            }
        }
        
        query.updateHandler = { query, samples, deletedObjects, newAnchor, error in
            if let samples = samples as? [HKQuantitySample], let latestSample = samples.last {
                let heartRateUnit = HKUnit(from: "count/min")
                let heartRateValue = latestSample.quantity.doubleValue(for: heartRateUnit)
                completion(heartRateValue, nil)
            } else {
                completion(nil, error)
            }
        }
        healthStore.execute(query)
    }
}
