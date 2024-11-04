//
//  HealthReport.swift
//  Health-Assistant
//
//  Created by wonhoKim on 11/4/24.
//

import Foundation

struct HealthReport: Identifiable {
    var id: Int
    var title: String
    var startDate: Date
    var endDate: Date

    var dateRange: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        let start = dateFormatter.string(from: startDate)
        let end = dateFormatter.string(from: endDate)
        return "\(start) - \(end)"
    }
}
