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
                ForEach(viewModel.events(for: day)) { event in
                    Text(event.title)
                        .onTapGesture {
                            selectedEvent = event
                        }
                }
            }
            .navigationTitle("\(day)일 일정")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("+") {
                        showAddEvent = true
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
