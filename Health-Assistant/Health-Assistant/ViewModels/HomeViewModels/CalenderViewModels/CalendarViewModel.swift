//
//  CalendarViewModel.swift
//  Health-Assistant
//
//  Created by Hwang_Inyoung on 11/4/24.
//

import SwiftUI
import SwiftData

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
    
    func startDayOffset() -> Int {
        let components = calendar.dateComponents([.year, .month], from: currentDate)
        guard let firstDayOfMonth = calendar.date(from: components),
              let weekday = calendar.dateComponents([.weekday], from: firstDayOfMonth).weekday else {
            return 0
        }
        return (weekday - 1) % 7 // 요일을 일요일 시작에 맞춤 (일요일이 0)
    }
    
    func events(for day: Int, context: ModelContext) -> [CalendarEvent] {
        let descriptor = FetchDescriptor<CalendarEvent>()
        let allEvents = (try? context.fetch(descriptor)) ?? []
        
        let filteredEvents = allEvents.filter { event in
            let eventDateComponents = calendar.dateComponents([.year, .month, .day], from: event.startTime)
            let currentDateComponents = calendar.dateComponents([.year, .month, .day], from: currentDate)
            
            return eventDateComponents.year == currentDateComponents.year &&
                   eventDateComponents.month == currentDateComponents.month &&
                   eventDateComponents.day == day
        }
        return filteredEvents.sorted { $0.startTime < $1.startTime }
    }
    
    func addEvent(event: CalendarEvent, context: ModelContext) {
        context.insert(event)
    }
    
    func removeEvent(eventID: UUID, context: ModelContext) {
        let descriptor = FetchDescriptor<CalendarEvent>(
            predicate: #Predicate { $0.id == eventID }
        )
        if let eventToDelete = (try? context.fetch(descriptor))?.first {
            context.delete(eventToDelete)
            calendarEvents.removeAll { $0.id == eventID }
        }
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
    
    // 특정 날짜에 현재 시간을 적용한 시작 및 종료 시간 반환
    func getStartAndEndTime(for day: Int) -> (startTime: Date, endTime: Date) {
        let now = Date()
        if let selectedDayStart = startOfDay(for: day) {
            var components = calendar.dateComponents([.year, .month, .day], from: selectedDayStart)
            let timeComponents = calendar.dateComponents([.hour, .minute, .second], from: now)
            
            components.hour = timeComponents.hour
            components.minute = timeComponents.minute
            components.second = timeComponents.second
            
            let startTime = calendar.date(from: components) ?? now
            let endTime = calendar.date(byAdding: .hour, value: 1, to: startTime) ?? startTime
            
            return (startTime: startTime, endTime: endTime)
        } else {
            let endTime = calendar.date(byAdding: .hour, value: 1, to: now) ?? now
            return (startTime: now, endTime: endTime)
        }
    }
    
    // 현재 주의 날짜들을 가져오는 메서드
    func currentWeekDates() -> [Date] {
        let calendar = Calendar.current
        let today = Date()
        let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: today)) ?? today
        var dates = [Date]()
        for i in 0..<7 {
            if let date = calendar.date(byAdding: .day, value: i, to: startOfWeek) {
                dates.append(date)
            }
        }
        return dates
    }
    
    // 요일과 날짜 포맷 (예: "월 5")
    func formattedDateForWeekView(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "E d"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: date)
    }
    
    // 특정 날짜의 이벤트 필터링
    func events(for date: Date, context: ModelContext) -> [CalendarEvent] {
        let calendar = Calendar.current
        return calendarEvents.filter { event in
            calendar.isDate(event.startTime, inSameDayAs: date)
        }
    }
    
    // 오늘 날짜인지 확인하는 메서드
    func isToday(_ date: Date) -> Bool {
        Calendar.current.isDateInToday(date)
    }
    
    func loadEvents(context: ModelContext) {
        let descriptor = FetchDescriptor<CalendarEvent>(
            sortBy: [SortDescriptor(\.startTime, order: .forward)] // 오름차순 정렬
        )
        if let allEvents = try? context.fetch(descriptor) {
            calendarEvents = allEvents
        } else {
            calendarEvents = []
        }
    }
}
