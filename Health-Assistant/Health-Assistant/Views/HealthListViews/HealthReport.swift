//
//  HealthReport.swift
//  Health-Assistant
//
//  Created by wonhoKim on 11/4/24.
//

import Foundation

//필요한 건강데이터는 호흡수 수면, 심박수, 체온, 심전도, 산소포화도 데이터들 추가해야함

struct HealthReport: Identifiable {
    var id: Int
    var title: String
    var startDate: Date
    var endDate: Date
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
    var dateRange: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        let start = dateFormatter.string(from: startDate)
        let end = dateFormatter.string(from: endDate)
        return "\(start) - \(end)"
    }
 
}
