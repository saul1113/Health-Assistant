//
//  DayEventsView.swift
//  Health-Assistant
//
//  Created by Hwang_Inyoung on 11/4/24.
//

import SwiftUI

struct DayEventsView: View {
    @ObservedObject var viewModel: CalendarViewModel
    let day: Int
    @State private var showAddEvent = false
    @State private var selectedEvent: CalendarEvent?
    
    var body: some View {
        NavigationView {
            List {
                if viewModel.events(for: day).isEmpty {
                    Text("일정이 없습니다.")
                        .font(.medium16)
                        .foregroundStyle(.gray)
                } else  {
                    ForEach(viewModel.events(for: day)) { event in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(viewModel.formattedTime(for: event))
                                    .font(.regular20)
                                    .foregroundStyle(.gray)
                                
                                Text(event.title)
                                    .font(.medium24)
                            }
                        }
                        .onTapGesture {
                            selectedEvent = event
                        }
                    }
                }
            }
            .listStyle(.inset)
            .toolbar {
                ToolbarItem(placement: .principal) { // 타이틀 커스터마이징
                    Text("\(viewModel.displayedMonthYear) \(day)일 일정")
                        .font(.bold24)
                        .foregroundColor(.green) // 원하는 색상으로 변경 가능
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showAddEvent = true
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.bold24)
                            .foregroundColor(.green) // 원하는 색상으로 변경 가능
                    }
                }
            }
            .sheet(isPresented: $showAddEvent) {
                AddEventView(viewModel: viewModel, day: day)
            }
            .sheet(item: $selectedEvent) { event in
                EditEventView(viewModel: viewModel, day: day, event: event)
            }
        }
    }
}

