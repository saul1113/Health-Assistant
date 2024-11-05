//
//  HealthReport.swift
//  Health-Assistant
//
//  Created by wonhoKim on 11/4/24.
//

import Foundation
//리포트 데이터 더미
//필요한 건강데이터는 호흡수 수면, 심박수, 체온, 심전도, 산소포화도


struct HealthReport: Identifiable {
    var id: Int
    var title: String
    var startDate: Date
    var endDate: Date
    var content: String
//    var breathRate: Double // 호흡수
//       var heartRate: Double  // 심박수
//       var temperature: Double // 체온
//       var avgHeartRate: Double // 평균 심박수
//       var restingHeartRate: Double // 휴식기 심박수
//       var ecgStatus: String  // 심전도 상태
//       var oxygenSaturation: Double // 산소포화도
    var dateRange: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        let start = dateFormatter.string(from: startDate)
        let end = dateFormatter.string(from: endDate)
        return "\(start) - \(end)"
    }
}
