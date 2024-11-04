//
//  CalendarViewModel.swift
//  Health-Assistant
//
//  Created by Hwang_Inyoung on 11/4/24.
//

import SwiftUI

class CalendarViewModel: ObservableObject {
    @Published var currentDate: Date
    @Published var eventsByDay: [Int: [CalendarEvent]] = [:]
    @Published var displayedMonthYear: String = ""
    
    private var calendar = Calendar.current
    
    init() {
        self.currentDate = Date()
        updateMonthYearDisplay()
        loadSampleEvents()
    }
    
    func updateMonthYearDisplay() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 M월"
        displayedMonthYear = dateFormatter.string(from: currentDate)
    }
    
    func moveToNextMonth() {
        if let nextMonth = calendar.date(byAdding: .month, value: 1, to: currentDate) {
            currentDate = nextMonth
            updateMonthYearDisplay()
        }
    }
    
    func moveToPreviousMonth() {
        if let previousMonth = calendar.date(byAdding: .month, value: -1, to: currentDate) {
            currentDate = previousMonth
            updateMonthYearDisplay()
        }
    }
    
    func updateYear(_ year: Int) {
        var components = calendar.dateComponents([.month, .day], from: currentDate)
        components.year = year
        if let newDate = calendar.date(from: components) {
            currentDate = newDate
            updateMonthYearDisplay()
        }
    }
    
    func events(for day: Int) -> [CalendarEvent] {
        return eventsByDay[day] ?? []
    }
    
    func addEvent(for day: Int, event: CalendarEvent) {
        if eventsByDay[day] != nil {
            eventsByDay[day]?.append(event)
        } else {
            eventsByDay[day] = [event]
        }
    }
    
    func removeEvent(for day: Int, eventID: UUID) {
        if let events = eventsByDay[day] {
            eventsByDay[day] = events.filter { $0.id != eventID }
            if eventsByDay[day]?.isEmpty == true {
                eventsByDay.removeValue(forKey: day)
            }
        }
    }
    
    private func loadSampleEvents() {
        // 임시 데이터 예제
        eventsByDay = [
            8: [CalendarEvent(title: "비타민 약 복용", startTime: Date(), endTime: Date(), isAllDay: true, alert: .tenMinutesBefore, notes: "아침 복용", content: "매일 아침 복용하세요")],
            15: [CalendarEvent(title: "병원 예약", startTime: Date(), endTime: Date(), isAllDay: false, alert: .oneHourBefore, notes: "주치의 상담", content: "정기 검진")]
        ]
    }
}
