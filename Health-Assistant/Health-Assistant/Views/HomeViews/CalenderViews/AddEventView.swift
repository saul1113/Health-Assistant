//
//  AddEventView.swift
//  Health-Assistant
//
//  Created by Hwang_Inyoung on 11/4/24.
//

import SwiftUI

struct AddEventView: View {
    @ObservedObject var viewModel: CalendarViewModel
    let day: Int // 선택한 날짜를 전달받아 해당 날짜에 이벤트를 추가하도록 설정
    @Environment(\.dismiss) var dismiss
    
    @State private var title: String = ""
    @State private var isAllDay: Bool = false
    @State private var startTime: Date
    @State private var endTime: Date
    @State private var alert: EventAlert = .none
    @State private var notes: String = ""
    private let notesCharacterLimit = 50
    
    init(viewModel: CalendarViewModel, day: Int) {
        self.viewModel = viewModel
        self.day = day
        
        // 선택한 날짜의 시작 시간과 종료 시간을 초기화
        if let startOfDay = viewModel.startOfDay(for: day) {
            _startTime = State(initialValue: startOfDay)
            _endTime = State(initialValue: viewModel.dateByAddingHours(1, to: startOfDay) ?? startOfDay)
        } else {
            _startTime = State(initialValue: Date())
            _endTime = State(initialValue: Date().addingTimeInterval(3600))
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                ScrollView {
                    VStack(spacing: 20) {
                        SectionView(header: "제목") {
                            ZStack {
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.green.opacity(0.5), lineWidth: 3)
                                    .background(Color.white.cornerRadius(8)) // 입력하는 부분 흰색 배경
                                
                                TextField("제목을 입력해주세요", text: $title)
                                    .font(.bold20)
                                    .padding(8)
                                    .background(Color.clear)
                            }
                        }
                        
                        SectionView(header: "시간 설정") {
                            HStack {
                                Image(systemName: "hourglass")
                                    .foregroundColor(.green)
                                Toggle("종일", isOn: $isAllDay)
                            }
                            VStack {
                                DatePicker("시작 시간", selection: $startTime)
                                    .padding()
                                    .background(Color.green.opacity(0.2))
                                    .cornerRadius(8)
                                    .font(.regular18)
                                
                                DatePicker("종료 시간", selection: $endTime)
                                    .padding()
                                    .background(Color.green.opacity(0.2))
                                    .cornerRadius(8)
                                    .font(.regular18)
                            }
                        }
                        
                        SectionView(header: "알림") {
                            HStack {
                                Image(systemName: "deskclock.fill")
                                    .foregroundColor(.green)
                                
                                Text("미리알림")
                                
                                Spacer()
                                
                                Picker("미리알림", selection: $alert) {
                                    ForEach(EventAlert.allCases) { alertOption in
                                        Text(alertOption.rawValue).tag(alertOption)
                                    }
                                }
                                .pickerStyle(MenuPickerStyle())
                                .font(.bold24)
                            }
                            .font(.regular18)
                        }
                        
                        SectionView(header: "메모") {
                            ZStack {
                                Color.green.opacity(0.2)
                                    .cornerRadius(8)
                                TextEditor(text: $notes)
                                    .frame(height: 100)
                                    .padding(8)
                                    .font(.regular18)
                                    .background(Color.clear)
                                    .cornerRadius(8)
                                    .onChange(of: notes) {
                                        if notes.count > notesCharacterLimit {
                                            notes = String(notes.prefix(notesCharacterLimit))
                                        }
                                    }
                            }
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray.opacity(0.5))
                            )
                            
                            Text("\(notes.count)/\(notesCharacterLimit) 글자")
                                .font(.caption)
                                .foregroundColor(notes.count > notesCharacterLimit ? .red : .gray)
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("새 일정 추가")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("취소") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("저장") {
                        let newEvent = CalendarEvent(
                            title: title,
                            startTime: startTime,
                            endTime: endTime,
                            isAllDay: isAllDay,
                            alert: alert,
                            notes: notes
                        )
                        viewModel.addEvent(for: day, event: newEvent)
                        dismiss()
                    }
                }
            }
        }
    }
}

struct SectionView<Content: View>: View {
    let header: String
    let content: Content
    
    init(header: String, @ViewBuilder content: () -> Content) {
        self.header = header
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(header)
                .font(.headline)
                .padding(.leading, 5)
            VStack {
                content
            }
            .padding()
            .background(Color.white)
            .cornerRadius(8)
            .shadow(color: Color.gray.opacity(0.1), radius: 5, x: 0, y: 2)
        }
    }
}

#Preview {
    AddEventView(viewModel: CalendarViewModel(), day: 1)
}
