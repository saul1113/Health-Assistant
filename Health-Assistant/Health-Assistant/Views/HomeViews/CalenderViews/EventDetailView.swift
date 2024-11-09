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
                titleSection
                timeSection
                alertSection
                notesSection
                Spacer()
            }
            .padding()
        }
        .navigationTitle(formattedDate(for: event.startTime))
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                toolbarButtons
            }
        }
        .sheet(isPresented: $showEditEvent) {
            EventFormView(viewModel: viewModel, event: event)
        }
        .alert(isPresented: $showDeleteAlert) {
            deleteAlert
        }
    }
    
    private var titleSection: some View {
        VStack {
            Text(event.title)
                .font(.bold30)
                .padding()
                .foregroundColor(.customGreen)
                .cornerRadius(8)
        }
        .padding(.vertical)
    }
    
    private var timeSection: some View {
        SectionView(header: "시간") {
            HStack {
                Image(systemName: "clock.fill")
                    .foregroundColor(.customGreen)
                Text(formattedTime(for: event))
                    .font(.bold24)
                Spacer()
            }
        }
        .padding(.vertical, 5)
    }
    
    private var alertSection: some View {
        SectionView(header: "알림") {
            HStack {
                Image(systemName: "deskclock.fill")
                    .foregroundColor(.customGreen)
                Text(event.alert.rawValue)
                    .font(.regular20)
                Spacer()
            }
        }
        .padding(.vertical, 20)
    }
    
    private var notesSection: some View {
        SectionView(header: "메모") {
            Text(event.notes)
                .font(.regular20)
                .padding()
                .background(Color.customGreen.opacity(0.2))
                .cornerRadius(8)
        }
    }
    
    private var toolbarButtons: some View {
        HStack {
            Button(action: { showEditEvent = true }) {
                Text("편집")
                    .font(.regular20)
            }
            Button(action: { showDeleteAlert = true }) {
                Image(systemName: "trash")
                    .foregroundColor(.red)
                    .font(.regular18)
            }
        }
    }
    
    private var deleteAlert: Alert {
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
