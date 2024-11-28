//
//  HealthReport.swift
//  Health-Assistant
//
//  Created by wonhoKim on 11/4/24.
//
//case inBed = 0
//
//@available(iOS 16.0, *)
//case asleepUnspecified = 1
//
//@available(iOS, introduced: 8.0, deprecated: 16.0, renamed: "HKCategoryValueSleepAnalysis.asleepUnspecified")
//public static var asleep: HKCategoryValueSleepAnalysis { get }
//
//@available(iOS 10.0, *)
//case awake = 2
//
//@available(iOS 16.0, *)
//case asleepCore = 3
//
//@available(iOS 16.0, *)
//case asleepDeep = 4
//
//@available(iOS 16.0, *)
//case asleepREM = 5
import Foundation

struct HealthReport: Identifiable {
    var id: UUID
    var title: String  // 리포트 제목
    var date: Date
    var heartRate: Double  // 심박수
    var temperature: Double // 체온
    var breath: Int // 호흡
    var oxygenSaturation: Double // 산소포화도
    //코오 깊은 램 수면 시간만 일단 사용 , 정확히 이 세개 데이터 제외하고는 뭘 의미하는지 모르겠음 일단 작성은 해둠
    var inBedMinute: Double  // 수면 시작 전 침대에 있던 시간
    var asleepUnspecifiedMinute: Double  // 분류되지 않은 수면 시간
    var awakeMinute: Double  // 깨어 있는 시간
    var asleepCoreMinute: Double  // 코어 수면 시간
    var asleepDeepMinute: Double  // 깊은 수면 시간
    var asleepREMMinute: Double  // 렘 수면 시간
    
    // 각 수면 시간들을 시간과 분으로 변환하는 프로퍼티들
    var inBedTime: (hours: Int, minutes: Int) {
        return convertToHoursAndMinutes(minutes: inBedMinute)
    }
    
    var asleepUnspecifiedTime: (hours: Int, minutes: Int) {
        return convertToHoursAndMinutes(minutes: asleepUnspecifiedMinute)
    }
    
    var awakeTime: (hours: Int, minutes: Int) {
        return convertToHoursAndMinutes(minutes: awakeMinute)
    }
    
    var asleepCoreTime: (hours: Int, minutes: Int) {
        return convertToHoursAndMinutes(minutes: asleepCoreMinute)
    }
    
    var asleepDeepTime: (hours: Int, minutes: Int) {
        return convertToHoursAndMinutes(minutes: asleepDeepMinute)
    }
    
    var asleepREMTime: (hours: Int, minutes: Int) {
        return convertToHoursAndMinutes(minutes: asleepREMMinute)
    }
    
    var reportDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        dateFormatter.timeZone = TimeZone.current
        return dateFormatter.string(from: date)
    }
    

    // 분을 시간과 분으로 변환하는 함수
    private func convertToHoursAndMinutes(minutes: Double) -> (hours: Int, minutes: Int) {
        let totalMinutes = Int(minutes)
        let hours = totalMinutes / 3600  // 초를 시간으로 계산
        let remainingMinutes = totalMinutes % 60  // 나머지 분 계산
        return (hours, remainingMinutes)
    }
    
   
}


struct HealthReportSummary: Identifiable {
    var id: UUID
    var title: String
    var startDate: Date
    var endDate: Date
    var healthReports: [HealthReport]
    
    var dateRange: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        let start = dateFormatter.string(from: startDate)
        let end = dateFormatter.string(from: endDate)
        return "\(start) - \(end)"
    }
}
