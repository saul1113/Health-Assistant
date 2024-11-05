//
//  CalendarViewModel.swift
//  Health-Assistant
//
//  Created by Hwang_Inyoung on 11/4/24.
//

import SwiftUI
import Foundation

class CalendarViewModel: ObservableObject {
    @Published var currentDate: Date {
        didSet {
            updateMonthYearDisplay()
        }
    }
    @Published var displayedMonthYear: String = ""
    @Published var calendarEvents: [CalendarEvent] = []
    @Published var selectedDay: Int?
    
    private let calendar = Calendar.current
    private let today = Date()
    
    init() {
        self.currentDate = Date()
        self.selectedDay = todayDay
        updateMonthYearDisplay()
    }
    
    // 오늘의 날짜 (일)
    var todayDay: Int {
        calendar.component(.day, from: today)
    }
    
    // 현재 달과 년도가 오늘과 동일한지 확인
    func isCurrentMonthAndYear() -> Bool {
        let currentMonth = calendar.component(.month, from: currentDate)
        let currentYear = calendar.component(.year, from: currentDate)
        let todayMonth = calendar.component(.month, from: today)
        let todayYear = calendar.component(.year, from: today)
        
        return currentMonth == todayMonth && currentYear == todayYear
    }
    
    func updateMonthYearDisplay() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 M월"
        displayedMonthYear = dateFormatter.string(from: currentDate)
    }
    
    func moveToNextMonth() {
        if let nextMonth = calendar.date(byAdding: .month, value: 1, to: currentDate) {
            currentDate = nextMonth
        }
    }
    
    func moveToPreviousMonth() {
        if let previousMonth = calendar.date(byAdding: .month, value: -1, to: currentDate) {
            currentDate = previousMonth
        }
    }
    
    func updateYear(_ year: Int) {
        var components = calendar.dateComponents([.year, .month, .day], from: currentDate)
        components.year = year
        if let newDate = calendar.date(from: components) {
            currentDate = newDate
        }
    }
    
    func daysInCurrentMonth() -> Int {
        guard let range = calendar.range(of: .day, in: .month, for: currentDate) else {
            return 31
        }
        return range.count
    }
    
    // 월의 시작 요일을 계산하여 offset 반환
    func startDayOffset() -> Int {
        let components = calendar.dateComponents([.year, .month], from: currentDate)
        guard let firstDayOfMonth = calendar.date(from: components),
              let weekday = calendar.dateComponents([.weekday], from: firstDayOfMonth).weekday else {
            return 0
        }
        return (weekday - 1) % 7 // 요일을 일요일 시작에 맞춤 (일요일이 0)
    }
    
    func events(for day: Int) -> [CalendarEvent] {
        calendarEvents.filter { calendar.component(.day, from: $0.startTime) == day }
    }
    
    func addEvent(for day: Int, event: CalendarEvent) {
        calendarEvents.append(event)
    }
    
    func removeEvent(for day: Int, eventID: UUID) {
        calendarEvents.removeAll { $0.id == eventID }
    }
    
    // 선택한 날짜를 기준으로 그 날의 시작 시간 생성
    func startOfDay(for day: Int) -> Date? {
        var components = calendar.dateComponents([.year, .month], from: currentDate)
        components.day = day
        return calendar.date(from: components)
    }
    
    // 특정 시간 수를 더한 날짜 생성
    func dateByAddingHours(_ hours: Int, to date: Date) -> Date? {
        return calendar.date(byAdding: .hour, value: hours, to: date)
    }
    
    func formattedTime(for event: CalendarEvent) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "a h:mm" // "오전/오후 h:mm" 형식
        
        return "\(formatter.string(from: event.startTime)) - \(formatter.string(from: event.endTime))"
    }
}
