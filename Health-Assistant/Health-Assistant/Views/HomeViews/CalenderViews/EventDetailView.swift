//
//  EventDetailView.swift
//  Health-Assistant
//
//  Created by Hwang_Inyoung on 11/5/24.
//

import SwiftUI

struct EventDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @ObservedObject var viewModel: CalenderViewModel
    let day: Int
    @State var event: CalendarEvent
    @Environment(\.dismiss) var dismiss
    @State private var showEditEvent = false
    @State private var showDeleteAlert = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                VStack {
                    Text(event.title)
                        .font(.bold30)
                        .padding()
                        .foregroundStyle(.customGreen)
                        .cornerRadius(8)
                }
                .padding(.vertical)
                
                
                    HStack {
                        Image(systemName: "clock.fill")
                            .foregroundStyle(.customGreen)

                        Text("시간")
                        
                        Spacer()
                    }
                    .font(.regular18)
                    .padding(.vertical, -5)
                
                VStack {
                    Text("\(formattedTime(for: event))")
                        .font(.bold24)
                        .padding()
                        .cornerRadius(8)
                }
                
                VStack(alignment: .leading) {
                    HStack {
                        Image(systemName: "deskclock.fill")
                            .foregroundStyle(.customGreen)
                        Text("알림")
                        
                        Spacer()
                    }
                    .font(.regular18)
                    .padding(.vertical, -5)
                    
                    Text(String(event.alert.rawValue))
                        .font(.regular20)
                        .padding()
                        .cornerRadius(8)
                }
                .padding(.vertical, 20)
                
                VStack(alignment: .leading) {
                    HStack {
                        Image(systemName: "pencil")
                            .foregroundStyle(.customGreen)
                        Text("메모")
                    }
                    .font(.regular18)
                    .padding(.vertical, -5)
                    Text(event.notes)
                        .font(.regular20)
                        .padding()
                        .background(Color.customGreen.opacity(0.2))
                        .cornerRadius(8)
                }
                Spacer()
            }
            .padding()
        }
        .navigationTitle(formattedDate(for: event.startTime))
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                HStack {
                    Button(action: {
                        showEditEvent = true
                    }) {
                        Text("편집")
                            .font(.regular20)
                    }
                    
                    Button(action: {
                        showDeleteAlert = true
                    }) {
                        Image(systemName: "trash")
                            .foregroundColor(.red)
                            .font(.regular18)
                    }
                }
            }
        }
        .sheet(isPresented: $showEditEvent) {
            EditEventView(viewModel: viewModel, day: day, event: event)
        }
        .alert(isPresented: $showDeleteAlert) {
            Alert(
                title: Text("이벤트 삭제"),
                message: Text("이 이벤트를 삭제하시겠습니까?"),
                primaryButton: .destructive(Text("삭제")) {
                    viewModel.removeEvent(eventID: event.id, context: modelContext)
                    dismiss()
                },
                secondaryButton: .cancel(Text("취소"))
            )
        }
    }
    
    private func formattedTime(for event: CalendarEvent) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "a h:mm"
        return "\(formatter.string(from: event.startTime)) - \(formatter.string(from: event.endTime))"
    }
    
    private func formattedDate(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy년 M월 d일 (E)"
        return formatter.string(from: date)
    }
}

#Preview {
    EventDetailView(
        viewModel: CalenderViewModel(),
        day: 1,
        event: CalendarEvent(
            title: "예시 이벤트",
            startTime: Date(),
            endTime: Date().addingTimeInterval(3600),
            isAllDay: false,
            alert: .none,
            notes: "이것은 예시 메모입니다."
        )
    )
}
