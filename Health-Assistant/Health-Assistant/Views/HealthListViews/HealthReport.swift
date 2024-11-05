//
//  HealthReport.swift
//  Health-Assistant
//
//  Created by wonhoKim on 11/4/24.
//

import Foundation

struct HealthReport: Identifiable {
    var id: UUID
    var title: String  // 리포트 제목
    var date: Date
    var heartRate: Double  // 심박수
    var temperature: Double // 체온
    var breath: Int // 호흡
    var oxygenSaturation: Double // 산소포화도
    
    var reportDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        return dateFormatter.string(from: date)
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

