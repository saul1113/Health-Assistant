//
//  CalendarEvent.swift
//  Health-Assistant
//
//  Created by Hwang_Inyoung on 11/4/24.
//

import Foundation
import SwiftData

@Model
final class CalendarEvent: Identifiable, Equatable {
    @Attribute(.unique) var id: UUID = UUID()
    var title: String
    var startTime: Date
    var endTime: Date
    var isAllDay: Bool
    private var alertValue: String
    
    var alert: EventAlert {
        get {
            EventAlert(rawValue: alertValue) ?? .none // 기본값으로 .none 사용
        }
        set {
            alertValue = newValue.rawValue
        }
    }

    var notes: String
    
    init(title: String, startTime: Date, endTime: Date, isAllDay: Bool, alert: EventAlert, notes: String) {
        self.title = title
        self.startTime = startTime
        self.endTime = endTime
        self.isAllDay = isAllDay
        self.alertValue = alert.rawValue
        self.notes = notes
    }
    
    static func ==(lhs: CalendarEvent, rhs: CalendarEvent) -> Bool {
        return lhs.id == rhs.id
    }
}

enum EventAlert: String, CaseIterable, Identifiable {
    case oneDayBefore = "하루 전"
    case twoHoursBefore = "2시간 전"
    case oneHourBefore = "1시간 전"
    case thirtyMinutesBefore = "30분 전"
    case tenMinutesBefore = "10분 전"
    case fiveMinutesBefore = "5분 전"
    case atStart = "시작 시간에"
    case none = "알림 없음"
    
    var id: String { self.rawValue }
}
