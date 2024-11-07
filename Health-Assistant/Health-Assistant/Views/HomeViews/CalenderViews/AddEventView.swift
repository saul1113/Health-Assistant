//
//  AddEventView.swift
//  Health-Assistant
//
//  Created by Hwang_Inyoung on 11/4/24.
//

import SwiftUI

struct AddEventView: View {
    @Environment(\.modelContext) private var modelContext
    @ObservedObject var viewModel: CalenderViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var title: String = ""
    @State private var isAllDay: Bool = false
    @State private var startTime: Date
    @State private var endTime: Date
    @State private var alert: EventAlert = .none
    @State private var notes: String = ""
    private let notesCharacterLimit = 200
    
    @State private var showDiscardAlert = false
    @State private var isEdited = false
    
    init(viewModel: CalenderViewModel) {
        self.viewModel = viewModel
        
        if let selectedDay = viewModel.selectedDay,
           let selectedDate = viewModel.startOfDay(for: selectedDay) {
            _startTime = State(initialValue: selectedDate)
            _endTime = State(initialValue: Calendar.current.date(byAdding: .hour, value: 1, to: selectedDate) ?? Date())
        } else {
            _startTime = State(initialValue: Date())
            _endTime = State(initialValue: Calendar.current.date(byAdding: .hour, value: 1, to: Date()) ?? Date())
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                ScrollView {
                    VStack(spacing: 20) {
                        SectionView(header: "") {
                            ZStack {
                                TextField("제목을 입력해주세요", text: $title)
                                    .font(.bold20)
                                    .padding(8)
                                    .background(Color.clear)
                                    .onChange(of: title) {
                                        isEdited = true
                                    }
                                    .toolbar {
                                        ToolbarItemGroup(placement: .keyboard) {
                                            Spacer()
                                            Button("완료") {
                                                hideKeyboard()
                                            }
                                        }
                                    }
                            }
                        }
                        
                        SectionView(header: "") {
                            HStack {
                                Image(systemName: "hourglass")
                                    .foregroundColor(.customGreen)
                                Toggle("종일", isOn: $isAllDay)
                                    .onChange(of: isAllDay) {
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
                                        
                                        DatePicker("시작 시간", selection: $startTime, displayedComponents: isAllDay ? .date : [.date, .hourAndMinute])
                                            .labelsHidden() // 라벨 숨기기
                                            .padding(.horizontal, 8) // DatePicker에 가로 패딩 추가
                                            .font(.regular18)
                                            .onChange(of: startTime) {
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
                                            .frame(width: 230, height: 40)
                                        
                                        DatePicker("종료 시간", selection: $endTime, displayedComponents: isAllDay ? .date : [.date, .hourAndMinute])
                                            .labelsHidden()
                                            .padding(.horizontal, 8)
                                            .font(.regular18)
                                            .onChange(of: endTime) {
                                                isEdited = true
                                            }
                                    }
                                }
                            }
                        }
                        
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
                                .onChange(of: alert) {
                                    isEdited = true
                                }
                            }
                        }
                        
                        ZStack {
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
                    }
                    .padding()
                }
                .scrollDismissesKeyboard(.immediately)
            }
            .navigationTitle("새 일정 추가")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("취소") {
                        checkIfEditedBeforeDismissing()
                    }
                    .font(.regular18)
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
                        viewModel.addEvent(event: newEvent, context: modelContext)
                        dismiss()
                    }
                    .font(.regular18)
                }
            }
            .onDisappear {
                checkIfEditedBeforeDismissing()
            }
            .alert(isPresented: $showDiscardAlert) {
                Alert(
                    title: Text("이 새로운 일정을 폐기하시겠습니까?")
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
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

#Preview {
    AddEventView(viewModel: CalenderViewModel())
}
