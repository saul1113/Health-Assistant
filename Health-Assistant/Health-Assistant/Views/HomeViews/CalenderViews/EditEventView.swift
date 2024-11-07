//
//  EditEventView.swift
//  Health-Assistant
//
//  Created by Hwang_Inyoung on 11/4/24.
//

import SwiftUI

struct EditEventView: View {
    @Environment(\.modelContext) private var modelContext
    @ObservedObject var viewModel: CalendarViewModel
    let day: Int
    @State var event: CalendarEvent
    @Environment(\.dismiss) var dismiss
    
    @State private var showDiscardAlert = false
    @State private var isEdited = false
    private let notesCharacterLimit = 200
    
    var body: some View {
        NavigationView {
            ZStack {
                ScrollView {
                    VStack(spacing: 20) {
                        SectionView(header: "제목") {
                            ZStack {
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.green.opacity(0.5), lineWidth: 3)
                                    .background(Color.white.cornerRadius(8))
                                
                                TextField("제목을 입력해주세요", text: $event.title)
                                    .font(.bold20)
                                    .padding(8)
                                    .background(Color.clear)
                                    .onChange(of: event.title) {
                                        isEdited = true
                                    }
                            }
                        }
                        
                        SectionView(header: "시간 설정") {
                            HStack {
                                Image(systemName: "hourglass")
                                    .foregroundColor(.green)
                                Toggle("종일", isOn: $event.isAllDay)
                                    .onChange(of: event.isAllDay) {
                                        isEdited = true
                                    }
                            }
                            VStack {
                                DatePicker("시작 시간", selection: $event.startTime, displayedComponents: event.isAllDay ? .date : [.date, .hourAndMinute])
                                    .padding()
                                    .background(Color.green.opacity(0.2))
                                    .cornerRadius(8)
                                    .font(.regular18)
                                    .onChange(of: event.startTime) {
                                        isEdited = true
                                    }
                                
                                DatePicker("종료 시간", selection: $event.endTime, displayedComponents: event.isAllDay ? .date : [.date, .hourAndMinute])
                                    .padding()
                                    .background(Color.green.opacity(0.2))
                                    .cornerRadius(8)
                                    .font(.regular18)
                                    .onChange(of: event.endTime) {
                                        isEdited = true
                                    }
                            }
                        }
                        
                        SectionView(header: "알림") {
                            HStack {
                                Image(systemName: "deskclock.fill")
                                    .foregroundColor(.green)
                                Text("미리알림")
                                
                                Spacer()
                                
                                Picker("미리알림", selection: $event.alert) {
                                    ForEach(EventAlert.allCases) { alertOption in
                                        Text(alertOption.rawValue).tag(alertOption)
                                    }
                                }
                                .pickerStyle(MenuPickerStyle())
                                .font(.bold24)
                                .onChange(of: event.alert) {
                                    isEdited = true
                                }
                            }
                            .font(.regular18)
                        }
                        
                        ZStack {
                            SectionView(header: "메모") {
                                ZStack {
                                    Color.green.opacity(0.2)
                                        .cornerRadius(8)
                                    
                                    TextEditor(text: $event.notes)
                                        .frame(height: 140)
                                        .padding(8)
                                        .font(.regular18)
                                        .background(Color.clear)
                                        .cornerRadius(8)
                                        .onChange(of: event.notes) {
                                            isEdited = true
                                            if event.notes.count > notesCharacterLimit {
                                                event.notes = String(event.notes.prefix(notesCharacterLimit))
                                            }
                                        }
                                }
                            }
                            VStack {
                                HStack {
                                    Spacer()
                                    Text("\(event.notes.count)/\(notesCharacterLimit) 글자")
                                        .font(.caption)
                                        .foregroundColor(event.notes.count > notesCharacterLimit ? .red : .gray)
                                }
                                .padding(.trailing, 8)
                                Spacer()
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("일정 편집")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("취소") {
                        checkIfEditedBeforeDismissing()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("저장") {
                        if let index = viewModel.calendarEvents.firstIndex(where: { $0.id == event.id }) {
                            viewModel.calendarEvents[index] = event
                        }
                        dismiss()
                    }
                }
            }
            .alert(isPresented: $showDiscardAlert) {
                Alert(
                    title: Text("이 변경 사항을 폐기하시겠습니까?"),
                    message: Text("저장하지 않은 변경사항이 사라집니다."),
                    primaryButton: .destructive(Text("변경사항 폐기")) {
                        dismiss()
                    },
                    secondaryButton: .cancel(Text("계속 편집하기"))
                )
            }
        }
    }
    
    private func checkIfEditedBeforeDismissing() {
        if isEdited {
            showDiscardAlert = true
        } else {
            dismiss()
        }
    }
}

