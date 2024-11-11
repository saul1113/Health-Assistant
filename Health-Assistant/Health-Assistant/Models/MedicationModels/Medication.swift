//
//  Medication.swift
//  Health-Assistant
//
//  Created by 김수민 on 11/4/24.
//

import Foundation
import SwiftData

@Model
final class Medication: Identifiable, Equatable {
    @Attribute(.unique) var id: UUID = UUID()
    var name: String      // 약 이름
    var company: String   // 제약회사 이름
    var days: [String]    // 복용 요일
    var times: [String]   // 복용 시간
    var note: String     // 약에 관한 메모
    var isTaken: [Bool]   // 복용 시간에 대한 복용 여부
    
    init(name: String, company: String, days: [String], times: [String], note: String) {
        self.id = UUID()
        self.name = name
        self.company = company
        self.days = days
        self.times = times
        self.note = note
        self.isTaken = Array(repeating: false, count: times.count)
    }
    
    func translatedDays() -> [String] {
            return days.map { translateDayKorean($0) }
    }
}

func translateDayKorean(_ day: String) -> String {
    switch day.lowercased() {
    case "monday":
        return "월"
    case "tuesday":
        return "화"
    case "wednesday":
        return "수"
    case "thursday":
        return "목"
    case "friday":
        return "금"
    case "saturday":
        return "토"
    case "sunday":
        return "일"
    default:
        return day
    }
}


func formatTimeToString(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "hh:mm a"
    return formatter.string(from: date)
}
