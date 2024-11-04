//
//  EditEventView.swift
//  Health-Assistant
//
//  Created by Hwang_Inyoung on 11/4/24.
//

import SwiftUI

struct EditEventView: View {
    @ObservedObject var viewModel: CalendarViewModel
    let day: Int
    @State var event: CalendarEvent
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("기본 정보")) {
                    TextField("제목", text: $event.title)
                    Toggle("종일", isOn: $event.isAllDay)
                    DatePicker("시작 시간", selection: $event.startTime)
                    DatePicker("종료 시간", selection: $event.endTime)
                    Picker("알림", selection: $event.alert) {
                        ForEach(EventAlert.allCases) { alertOption in
                            Text(alertOption.rawValue).tag(alertOption)
                        }
                    }
                }
                
                Section(header: Text("메모")) {
                    TextEditor(text: $event.notes)
                }
                
            }
            .navigationTitle("일정 편집")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("저장") {
                        if let index = viewModel.calendarEvents.firstIndex(where: { $0.id == event.id }) {
                            viewModel.calendarEvents[index] = event
                        }
                        dismiss()
                    }
                }
                ToolbarItem(placement: .destructiveAction) {
                    Button("삭제") {
                        viewModel.removeEvent(for: day, eventID: event.id)
                        dismiss()
                    }
                }
            }
        }
    }
}
