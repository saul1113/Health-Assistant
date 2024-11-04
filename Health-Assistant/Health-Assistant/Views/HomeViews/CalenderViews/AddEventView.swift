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
    @State private var startTime: Date = Date()
    @State private var endTime: Date = Date()
    @State private var alert: EventAlert = .none
    @State private var notes: String = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.white // 전체 화면 배경을 흰색으로 설정
                    .edgesIgnoringSafeArea(.all)
                
                ScrollView {
                    VStack(spacing: 20) {
                        SectionView(header: "기본 정보") {
                            TextField("제목", text: $title)
                                .font(.headline)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(8)
                        }
                        
                        SectionView(header: "시간 설정") {
                            Toggle("종일", isOn: $isAllDay)
                            DatePicker("시작 시간", selection: $startTime)
                            DatePicker("종료 시간", selection: $endTime)
                        }
                        
                        SectionView(header: "알림") {
                            Picker("미리알림", selection: $alert) {
                                ForEach(EventAlert.allCases) { alertOption in
                                    Text(alertOption.rawValue).tag(alertOption)
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                        }
                        
                        SectionView(header: "메모") {
                            TextEditor(text: $notes)
                                .frame(height: 100)
                                .padding(4)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.gray.opacity(0.5))
                                )
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
