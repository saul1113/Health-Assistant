//
//  EventFormView.swift
//  Health-Assistant
//
//  Created by Hwang_Inyoung on 11/9/24.
//

import SwiftUI

struct EventFormView: View {
    @ObservedObject var viewModel: CalenderViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var title: String
    @State private var isAllDay: Bool
    @State private var startTime: Date
    @State private var endTime: Date
    @State private var alert: EventAlert
    @State private var notes: String
    private let notesCharacterLimit = 200
    
    @State private var showDiscardAlert = false
    @State private var isEdited = false
    let isEditing: Bool
    var event: CalendarEvent?
    
    init(viewModel: CalenderViewModel, event: CalendarEvent? = nil) {
        self.viewModel = viewModel
        self.event = event
        self.isEditing = event != nil
        
        // 이벤트가 존재하면 수정 모드로 불러오기
        if let event = event {
            _title = State(initialValue: event.title)
            _isAllDay = State(initialValue: event.isAllDay)
            _startTime = State(initialValue: event.startTime)
            _endTime = State(initialValue: event.endTime)
            _alert = State(initialValue: event.alert)
            _notes = State(initialValue: event.notes)
        } else {
            // 새로운 이벤트 추가 시
            let currentDate = Date()
            
            // 선택한 날짜가 있는 경우, 선택한 날짜의 현재 시간으로 설정
            if let selectedDay = viewModel.selectedDay,
               let selectedDate = viewModel.startOfDay(for: selectedDay) {
                _startTime = State(initialValue: Calendar.current.date(bySettingHour: Calendar.current.component(.hour, from: currentDate),
                                                                      minute: Calendar.current.component(.minute, from: currentDate),
                                                                      second: 0, of: selectedDate) ?? currentDate)
                _endTime = State(initialValue: Calendar.current.date(byAdding: .hour, value: 1, to: _startTime.wrappedValue) ?? currentDate)
            } else {
                // 선택한 날짜가 없으면 오늘 날짜의 현재 시간으로 설정
                _startTime = State(initialValue: currentDate)
                _endTime = State(initialValue: Calendar.current.date(byAdding: .hour, value: 1, to: currentDate) ?? currentDate)
            }
            
            _title = State(initialValue: "")
            _isAllDay = State(initialValue: false)
            _alert = State(initialValue: .none)
            _notes = State(initialValue: "")
        }
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    titleSection
                    allDayToggle
                    timeSelectionSection
                    alertSelectionSection
                    notesSection
                }
                .padding()
            }
            .navigationTitle(isEditing ? "일정 편집" : "새 일정 추가")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { cancelButton }
                ToolbarItem(placement: .confirmationAction) { saveButton }
            }
            .alert(isPresented: $showDiscardAlert) { discardAlert }
            .scrollDismissesKeyboard(.immediately)
        }
    }
    
    private var titleSection: some View {
        SectionView(header: "") {
            TextField("제목을 입력해주세요", text: $title)
                .font(.bold20)
                .padding(8)
                .background(Color.clear)
                .onChange(of: title) { isEdited = true }
        }
    }
    
    private var allDayToggle: some View {
        SectionView(header: "") {
            HStack {
                Image(systemName: "hourglass")
                    .foregroundColor(.customGreen)
                Toggle("종일", isOn: $isAllDay)
                    .onChange(of: isAllDay) { isEdited = true }
                    .font(.medium18)
            }
        }
    }
    
    private var timeSelectionSection: some View {
        SectionView(header: "") {
            timePicker(label: "시작", selection: $startTime)
            timePicker(label: "종료", selection: $endTime)
        }
    }
    
    private func timePicker(label: String, selection: Binding<Date>) -> some View {
        HStack {
            Text(label)
                .font(.medium18)
            Spacer()
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.customGreen.opacity(0.2))
                    .frame(width: 230, height: 50)
                
                DatePicker("", selection: selection, displayedComponents: isAllDay ? .date : [.date, .hourAndMinute])
                    .labelsHidden()
                    .padding(.horizontal, 8)
                    .font(.regular18)
                    .onChange(of: selection.wrappedValue) { isEdited = true }
            }
        }
    }
    
    private var alertSelectionSection: some View {
        SectionView(header: "") {
            HStack {
                Image(systemName: "deskclock.fill")
                    .foregroundColor(.customGreen)
                Text("알림")
                    .font(.medium18)
                Spacer()
                Picker("미리알림", selection: $alert) {
                    ForEach(EventAlert.allCases) { alertOption in
                        Text(alertOption.rawValue).tag(alertOption)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .font(.medium20)
                .onChange(of: alert) { isEdited = true }
            }
        }
    }
    
    private var notesSection: some View {
        SectionView(header: "") {
            HStack {
                Image(systemName: "pencil")
                    .foregroundColor(.customGreen)
                Text("메모")
                    .font(.medium20)
                Spacer()
                Text("\(notes.count)/\(notesCharacterLimit) 글자")
                    .font(.caption)
                    .foregroundColor(notes.count > notesCharacterLimit ? .red : .gray)
            }
            ZStack {
                Color.customGreen.opacity(0.2)
                    .cornerRadius(8)
                TextEditor(text: $notes)
                    .frame(height: 140)
                    .padding(8)
                    .font(.regular18)
                    .background(Color.clear)
                    .cornerRadius(8)
                    .onChange(of: notes) {
                        isEdited = true
                        if notes.count > notesCharacterLimit {
                            notes = String(notes.prefix(notesCharacterLimit))
                        }
                    }
            }
        }
    }
    
    private var cancelButton: some View {
        Button("취소") { checkIfEditedBeforeDismissing() }
            .font(.regular18)
    }
    
    private var saveButton: some View {
        Button("저장") {
            if isEditing, let event = event {
                viewModel.updateEvent(event: CalendarEvent(title: title, startTime: startTime, endTime: endTime, isAllDay: isAllDay, alert: alert, notes: notes))
            } else {
                let newEvent = CalendarEvent(title: title, startTime: startTime, endTime: endTime, isAllDay: isAllDay, alert: alert, notes: notes)
                viewModel.addEvent(event: newEvent)
            }
            dismiss()
        }
        .font(.regular18)
    }
    
    private var discardAlert: Alert {
        Alert(
            title: Text("이 변경 사항을 폐기하시겠습니까?")
                .font(.bold20),
            message: Text("저장하지 않은 변경사항이 사라집니다.")
                .font(.regular16),
            primaryButton: .destructive(Text("변경사항 폐기").font(.regular18)) { dismiss() },
            secondaryButton: .cancel(Text("계속 편집하기").font(.regular18))
        )
    }
    
    private func checkIfEditedBeforeDismissing() {
        if isEdited {
            showDiscardAlert = true
        } else {
            dismiss()
        }
    }
}
