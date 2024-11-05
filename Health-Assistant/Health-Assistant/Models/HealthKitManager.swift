//
//  HealthKitManager.swift
//  Health-Assistant
//
//  Created by 강희창 on 11/5/24.
//

import HealthKit
import UIKit

class HealthKitManager {
    private let healthStore = HKHealthStore()
    
    // HealthKit 권한 요청 메서드
    func requestAuthorization(completion: @escaping (Bool, Error?) -> Void) {
        guard let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate),
              let sleepType = HKObjectType.categoryType(forIdentifier: .sleepAnalysis) else {
            completion(false, NSError(domain: "HealthKitManager", code: 1, userInfo: [NSLocalizedDescriptionKey: "잘못된 HealthKit 데이터 유형"]))
            return
        }
        
        let readTypes: Set<HKObjectType> = [heartRateType, sleepType]
        
        healthStore.requestAuthorization(toShare: [], read: readTypes) { success, error in
            completion(success, error)
        }
    }
    
    // HealthKit 권한 상태 확인 메서드
    func checkAuthorizationStatus(for type: HKObjectType) -> HKAuthorizationStatus {
        return healthStore.authorizationStatus(for: type)
    }
    
    // 설정 앱으로 이동
    func openHealthSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url)
        }
    }
}
