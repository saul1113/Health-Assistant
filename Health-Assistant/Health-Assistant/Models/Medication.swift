//
//  Medication.swift
//  Health-Assistant
//
//  Created by 김수민 on 11/4/24.
//

import Foundation

struct Medication: Identifiable {
    let id: UUID
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
    
    static let dummyList: [Medication] = [Medication(name: "혈압약", company: "대웅제약", days:  ["thursday", "Friday"], times: ["08:00 AM", "02:00 PM"], note: "식후 30분 후에 복용하기"),
                                          Medication(name: "진통제", company: "동국제약",days:  ["Wednesday", "thursday", "Friday"], times: ["08:00 AM", "02:00 PM", "10:00 PM"], note: "부작용 있을 수 있음"),
                                       Medication(name: "영양제", company: "뉴젠팜",days:  ["thursday"], times: ["08:00 AM", "02:00 PM", "10:00 PM"], note: "물과 함게 복용하기. 음료수 안됨"),
                                          Medication(name: "타이레놀",company: "BMS 제약",days:  ["TuesDay","Friday"], times: ["08:00 AM", "02:00 PM", "10:00 PM"], note: "공복에 섭취하지 않기"),
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


func formatTimeToString(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "hh:mm a"
    return formatter.string(from: date)
}
