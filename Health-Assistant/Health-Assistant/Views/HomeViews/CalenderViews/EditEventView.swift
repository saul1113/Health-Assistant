//
//  EditEventView.swift
//  Health-Assistant
//
//  Created by Hwang_Inyoung on 11/4/24.
//

import SwiftUI

struct EditEventView: View {
    @Environment(\.modelContext) private var modelContext
    @ObservedObject var viewModel: CalenderViewModel
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
                        // Title Section
                        SectionView(header: "") {
                            TextField("제목을 입력해주세요", text: $event.title)
                                .font(.bold20)
                                .padding(8)
                                .background(Color.clear)
                                .onChange(of: event.title) {
                                    isEdited = true
                                }
                        }
                        
                        // Time Settings Section
                        SectionView(header: "") {
                            HStack {
                                Image(systemName: "hourglass")
                                    .foregroundColor(.customGreen)
                                Toggle("종일", isOn: $event.isAllDay)
                                    .onChange(of: event.isAllDay) {
                                        isEdited = true
                                    }
                                    .font(.medium18)
                            }
                            VStack(spacing: 20) {
                                HStack {
                                    Text("시작")
                                        .font(.medium18)
                                    
                                    Spacer()
                                    
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(Color.customGreen.opacity(0.2))
                                            .frame(width: 230, height: 50)
                                        
                                        DatePicker("시작 시간", selection: $event.startTime, displayedComponents: event.isAllDay ? .date : [.date, .hourAndMinute])
                                            .labelsHidden()
                                            .padding(.horizontal, 8)
                                            .font(.regular18)
                                            .onChange(of: event.startTime) {
                                                isEdited = true
                                            }
                                    }
                                }
                                
                                HStack {
                                    Text("종료")
                                        .font(.medium18)
                                    
                                    Spacer()
                                    
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(Color.customGreen.opacity(0.2))
                                            .frame(width: 230, height: 50)
                                        
                                        DatePicker("종료 시간", selection: $event.endTime, displayedComponents: event.isAllDay ? .date : [.date, .hourAndMinute])
                                            .labelsHidden()
                                            .padding(.horizontal, 8)
                                            .font(.regular18)
                                            .onChange(of: event.endTime) {
                                                isEdited = true
                                            }
                                    }
                                }
                            }
                        }
                        
                        // Alert Section
                        SectionView(header: "") {
                            HStack {
                                Image(systemName: "deskclock.fill")
                                    .foregroundColor(.customGreen)
                                
                                Text("알림")
                                    .font(.medium18)
                                
                                Spacer()
                                
                                Picker("미리알림", selection: $event.alert) {
                                    ForEach(EventAlert.allCases) { alertOption in
                                        Text(alertOption.rawValue).tag(alertOption)
                                    }
                                }
                                .pickerStyle(MenuPickerStyle())
                                .font(.medium20)
                                .onChange(of: event.alert) {
                                    isEdited = true
                                }
                            }
                        }
                        
                        // Notes Section
                        ZStack {
                            SectionView(header: "") {
                                HStack {
                                    Image(systemName: "pencil")
                                        .foregroundColor(.customGreen)
                                    
                                    Text("메모")
                                        .font(.medium20)
                                    
                                    Spacer()
                                    
                                    Text("\(event.notes.count)/\(notesCharacterLimit) 글자")
                                        .font(.caption)
                                        .foregroundColor(event.notes.count > notesCharacterLimit ? .red : .gray)
                                }
                                
                                ZStack {
                                    Color.customGreen.opacity(0.2)
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
                    .font(.regular18)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("저장") {
                        if let index = viewModel.calendarEvents.firstIndex(where: { $0.id == event.id }) {
                            viewModel.calendarEvents[index] = event
                        }
                        dismiss()
                    }
                    .font(.regular18)
                }
            }
            .alert(isPresented: $showDiscardAlert) {
                Alert(
                    title: Text("이 변경 사항을 폐기하시겠습니까?")
                        .font(.bold20),
                    message: Text("저장하지 않은 변경사항이 사라집니다.")
                        .font(.regular16),
                    primaryButton: .destructive(Text("변경사항 폐기").font(.regular18)) {
                        dismiss()
                    },
                    secondaryButton: .cancel(Text("계속 편집하기").font(.regular18))
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
