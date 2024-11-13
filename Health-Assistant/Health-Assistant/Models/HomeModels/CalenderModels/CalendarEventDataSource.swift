//
//  CalendarEventDataSource.swift
//  Health-Assistant
//
//  Created by Hwang_Inyoung on 11/13/24.
//

import Foundation
import SwiftData

final class CalendarEventDataSource {
    private let modelContainer: ModelContainer
    private let modelContext: ModelContext

    @MainActor
    static let shared = CalendarEventDataSource()

    @MainActor
    private init() {
        // `CalendarEvent`를 위한 독립적인 `modelContainer` 생성
        self.modelContainer = try! ModelContainer(for: CalendarEvent.self, configurations: ModelConfiguration(isStoredInMemoryOnly: false))
        self.modelContext = modelContainer.mainContext
        
        // 데이터 저장 경로 출력
        if let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            print("캘린더 data directory: \(url.path)")
        }
    }

    func fetchCalendarEvents() -> [CalendarEvent] {
        do {
            let events = try modelContext.fetch(FetchDescriptor<CalendarEvent>())
            return events
        } catch {
            print("캘린더 이벤트를 가져오는 중 오류 발생: \(error)")
            return []
        }
    }

    func addCalendarEvent(_ event: CalendarEvent) {
        modelContext.insert(event)
        do {
            try modelContext.save()
        } catch {
            print("캘린더 이벤트를 저장하는 중 오류 발생: \(error)")
        }
    }

    func deleteCalendarEvent(_ event: CalendarEvent) {
        modelContext.delete(event)
        do {
            try modelContext.save()
        } catch {
            print("캘린더 이벤트 삭제 중 오류 발생: \(error)")
        }
    }
    
    func updateCalendarEvent(_ event: CalendarEvent) {
        do {
            try modelContext.save()
        } catch {
            print("캘린더 이벤트 업데이트 중 오류 발생: \(error)")
        }
    }
}
