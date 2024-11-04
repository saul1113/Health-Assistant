//
//  AddEventView.swift
//  Health-Assistant
//
//  Created by Hwang_Inyoung on 11/4/24.
//

import SwiftUI

struct AddEventView: View {
    @ObservedObject var viewModel: CalendarViewModel
    let day: Int
    @Environment(\.dismiss) var dismiss
    
    @State private var title: String = ""
    @State private var isAllDay: Bool = false
    @State private var startTime: Date = Date()
    @State private var endTime: Date = Date()
    @State private var alert: EventAlert = .none
    @State private var notes: String = ""
    @State private var content: String = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("기본 정보")) {
                    TextField("제목", text: $title)
                    Toggle("종일", isOn: $isAllDay)
                    DatePicker("시작 시간", selection: $startTime)
                    DatePicker("종료 시간", selection: $endTime)
                    Picker("알림", selection: $alert) {
                        ForEach(EventAlert.allCases) { alertOption in
                            Text(alertOption.rawValue).tag(alertOption)
                        }
                    }
                }
                
                Section(header: Text("메모")) {
                    TextEditor(text: $notes)
                }
                
                Section(header: Text("본문")) {
                    TextEditor(text: $content)
                }
            }
            .navigationTitle("새 일정")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("취소") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("저장") {
                        let newEvent = CalendarEvent(title: title, startTime: startTime, endTime: endTime, isAllDay: isAllDay, alert: alert, notes: notes, content: content)
                        viewModel.addEvent(for: day, event: newEvent)
                        dismiss()
                    }
                }
            }
        }
    }
}
