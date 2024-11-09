//
//  DayEventsView.swift
//  Health-Assistant
//
//  Created by Hwang_Inyoung on 11/4/24.
//

import SwiftUI

struct DayEventsView: View {
    @Environment(\.modelContext) private var modelContext
    @ObservedObject var viewModel: CalenderViewModel
    let day: Int
    @State private var selectedEvent: CalendarEvent?
    
    var body: some View {
        NavigationView {
            List {
                if viewModel.events(for: day, context: modelContext).isEmpty {
                    emptyEventText()
                } else {
                    eventList()
                }
            }
            .listStyle(.inset)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("\(viewModel.displayedMonthYear) \(day)일 일정")
                        .font(.bold24)
                        .foregroundColor(.customGreen)
                }
            }
        }
        .accentColor(Color("CustomGreen"))
    }
    
    private func emptyEventText() -> some View {
        Text("일정이 없습니다.")
            .font(.medium16)
            .foregroundColor(.gray)
    }
    
    private func eventList() -> some View {
        ForEach(viewModel.events(for: day, context: modelContext)) { event in
            NavigationLink(destination: EventDetailView(viewModel: viewModel, day: day, event: event)
                .onDisappear {
                    viewModel.loadEvents(context: modelContext)
                }
            ) {
                EventRow(event: event, viewModel: viewModel)
            }
        }
    }
}

struct EventRow: View {
    let event: CalendarEvent
    let viewModel: CalenderViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(viewModel.formattedTime(for: event))
                .font(.regular20)
                .foregroundColor(.gray)
            
            Text(event.title)
                .font(.medium24)
        }
    }
}
