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
    
    init(viewModel: CalenderViewModel, startTime: Date = Date(), endTime: Date = Date()) {
        self.viewModel = viewModel
        _startTime = State(initialValue: startTime)
        _endTime = State(initialValue: endTime)
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
                                    .background(Color.white.cornerRadius(8))
                                
                                TextField("제목을 입력해주세요", text: $title)
                                    .font(.bold20)
                                    .padding(8)
                                    .background(Color.clear)
                                    .onChange(of: title) {
                                        isEdited = true
                                    }
                                    .toolbar {
                                        ToolbarItemGroup(placement: .keyboard) {
                                            Spacer() // 오른쪽 정렬
                                            Button("완료") {
                                                hideKeyboard()
                                            }
                                        }
                                    }
                            }
                        }
                        
                        SectionView(header: "시간 설정") {
                            HStack {
                                Image(systemName: "hourglass")
                                    .foregroundColor(.green)
                                Toggle("종일", isOn: $isAllDay)
                                    .onChange(of: isAllDay) {
                                        isEdited = true
                                    }
                            }
                            VStack {
                                DatePicker("시작 시간", selection: $startTime, displayedComponents: isAllDay ? .date : [.date, .hourAndMinute])
                                    .padding()
                                    .background(Color.green.opacity(0.2))
                                    .cornerRadius(8)
                                    .font(.regular18)
                                    .onChange(of: startTime) {
                                        isEdited = true
                                    }
                                
                                DatePicker("종료 시간", selection: $endTime,displayedComponents: isAllDay ? .date : [.date, .hourAndMinute])
                                    .padding()
                                    .background(Color.green.opacity(0.2))
                                    .cornerRadius(8)
                                    .font(.regular18)
                                    .onChange(of: endTime) {
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
                                
                                Picker("미리알림", selection: $alert) {
                                    ForEach(EventAlert.allCases) { alertOption in
                                        Text(alertOption.rawValue).tag(alertOption)
                                    }
                                }
                                .pickerStyle(MenuPickerStyle())
                                .font(.bold24)
                                .onChange(of: alert) {
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
                            VStack {
                                HStack {
                                    Spacer()
                                    Text("\(notes.count)/\(notesCharacterLimit) 글자")
                                        .font(.caption)
                                        .foregroundColor(notes.count > notesCharacterLimit ? .red : .gray)
                                }
                                .padding(.trailing, 8)
                                Spacer()
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
                }
            }
            .onDisappear {
                checkIfEditedBeforeDismissing()
            }
            .alert(isPresented: $showDiscardAlert) {
                Alert(
                    title: Text("이 새로운 일정을 폐기하시겠습니까?"),
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
    
    // 키보드 숨김 함수
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

#Preview {
    AddEventView(viewModel: CalenderViewModel(), startTime: Date(), endTime: Date())
}
