//
//  CalendarEvent.swift
//  Health-Assistant
//
//  Created by Hwang_Inyoung on 11/4/24.
//

import Foundation

struct CalendarEvent: Identifiable, Equatable {
    let id = UUID()
    var title: String
    var startTime: Date
    var endTime: Date
    var isAllDay: Bool
    var alert: EventAlert
    var notes: String
}

enum EventAlert: String, CaseIterable, Identifiable {
    case tenMinutesBefore = "10분 전"
    case oneHourBefore = "1시간 전"
    case atStart = "시작 시간에"
    case none = "알림 없음"
    
    var id: String { self.rawValue }
}
