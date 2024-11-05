//
//  Medison.swift
//  Health-Assistant
//
//  Created by 김수민 on 11/4/24.
//

import Foundation

struct Medison: Identifiable {
    let id: UUID
    var name: String      // 약 이름
    var days: [String]    // 복용 요일
    var times: [String]   // 복용 시간
    var note: String     // 약에 관한 메모
    var isTaken: [Bool]   // 복용 시간에 대한 복용 여부
    
    init(name: String, days: [String], times: [String], note: String) {
        self.id = UUID()
        self.name = name
        self.days = days
        self.times = times
        self.note = note
        self.isTaken = Array(repeating: false, count: times.count)
    }
    
    func translatedDays() -> [String] {
            return days.map { translateDayKorean($0) }
    }
    
    static let dummyList: [Medison] = [Medison(name: "약 이름 1", days:  ["Monday", "Wednesday", "Friday"], times: ["08:00 AM", "02:00 PM"], note: "공복에 복용하면 안됨"),
                                       Medison(name: "약 이름 2", days:  ["TuesDay","Friday"], times: ["08:00 AM"], note: "공복에 복용하면 안됨"),
                                       Medison(name: "약 이름 3", days:  ["Monday", "TuesDay", "ThursDay"], times: ["08:00 AM", "02:00 PM", "10:00 PM"], note: "공복에 복용하면 안됨")
    ]
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
