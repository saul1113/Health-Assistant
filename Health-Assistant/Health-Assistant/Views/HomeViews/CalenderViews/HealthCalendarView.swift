//
//  HealthCalendarView.swift
//  Health-Assistant
//
//  Created by Hwang_Inyoung on 11/4/24.
//

import SwiftUI

struct HealthCalendarView: View {
    @ObservedObject var viewModel = CalenderViewModel()
    @State private var showDayEvents = false
    @State private var showAddEvent = false
    @State private var showEventForm = false
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                headerView(geometry: geometry)
                
                dayHeaders()
                    .padding(.bottom, -30)
                
                dateGridView(geometry: geometry)
                
                Spacer()
            }
            .sheet(isPresented: $showEventForm) {
                EventFormView(viewModel: viewModel)
                    .onDisappear {
                        viewModel.loadEvents()
                    }
            }
            .sheet(isPresented: $showDayEvents) {
                if let selectedDay = viewModel.selectedDay {
                    DayEventsView(viewModel: viewModel, day: selectedDay)
                        .presentationDetents([.large])
                }
            }
            .onAppear {
                viewModel.loadEvents()
            }
        }
    }
    
    private func headerView(geometry: GeometryProxy) -> some View {
        HStack {
            yearMonthPicker()
            
            Spacer()
            
            monthNavigationButtons()
            
            addEventButton()
        }
        .padding(.horizontal)
        .padding(.top, geometry.size.height * 0.02)
    }
    
    private func yearMonthPicker() -> some View {
        Menu {
            ForEach(2020...2030, id: \.self) { year in
                Button("\(year)년") {
                    viewModel.updateYear(year)
                }
            }
        } label: {
            Text(viewModel.displayedMonthYear)
                .font(.bold28)
                .foregroundStyle(.black)
        }
    }
    
    private func monthNavigationButtons() -> some View {
        HStack {
            Button(action: { viewModel.moveToPreviousMonth() }) {
                Image(systemName: "chevron.left")
                    .font(.bold24)
            }
            
            Button(action: { viewModel.moveToNextMonth() }) {
                Image(systemName: "chevron.right")
                    .font(.bold24)
            }
        }
    }
    
    private func addEventButton() -> some View {
        Button(action: {
            showEventForm = true
        }) {
            Image(systemName: "plus.circle.fill")
                .font(.bold24)
                .foregroundColor(.customGreen)
        }
        .padding(.leading)
    }
    
    private func dayHeaders() -> some View {
        DayHeadersView()
        .padding(.horizontal)
    }
    
    private func dateGridView(geometry: GeometryProxy) -> some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: geometry.size.height * 0.01) {
            ForEach(0..<viewModel.startDayOffset() + viewModel.daysInCurrentMonth(), id: \.self) { index in
                if index < viewModel.startDayOffset() {
                    EmptyCell(geometry: geometry)
                } else {
                    let day = index - viewModel.startDayOffset() + 1
                    DayCellView(day: day, geometry: geometry, viewModel: viewModel)
                        .onTapGesture {
                            viewModel.selectedDay = day
                            showDayEvents = true
                        }
                }
            }
        }
        .padding()
    }
}

struct EmptyCell: View {
    let geometry: GeometryProxy
    
    var body: some View {
        Text(" ")
            .frame(height: geometry.size.height * 0.06)
    }
}

struct DayCellView: View {
    @Environment(\.modelContext) private var modelContext
    let day: Int
    let geometry: GeometryProxy
    let viewModel: CalenderViewModel
    
    var body: some View {
        ZStack {
            VStack {
                Text("\(day)")
                    .padding(geometry.size.width * 0.015)
                    .frame(maxWidth: .infinity)
                    .background(dayBackgroundColor())
                    .clipShape(Circle())
                    .font(.semibold18)
                
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: geometry.size.height * 0.005) {
                Spacer()
                
                let events = viewModel.events(for: day)
                
                EventTexts(viewModel: viewModel, day: day, geometry: geometry)
            }
            .padding(.top, geometry.size.height * 0.04)
        }
        .frame(height: geometry.size.height * 0.12)
    }
    
    private func dayBackgroundColor() -> Color {
        let hasEvents = !viewModel.events(for: day).isEmpty
        
        if day == viewModel.todayDay && viewModel.isCurrentMonthAndYear() {
            return Color.blue.opacity(0.3)
        } else if day == viewModel.selectedDay {
            return Color.customGreen.opacity(0.5)
        } else if hasEvents {
            return Color.customGreen.opacity(0.2)
        } else {
            return Color.clear
        }
    }
}

struct EmptyEventPlaceholders: View {
    let geometry: GeometryProxy
    
    var body: some View {
        VStack {
            Text(" ")
                .font(.regular8)
                .frame(width: geometry.size.width * 0.134, height: geometry.size.height * 0.024)
                .padding(geometry.size.width * 0.005)
                .opacity(0)
        }
    }
}

struct EventTexts: View {
    let viewModel: CalenderViewModel
    let day: Int
    let geometry: GeometryProxy
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
            VStack(alignment: .leading, spacing: geometry.size.height * 0.0042) {
                let dayEvents = viewModel.events(for: day)

                ForEach(dayEvents.prefix(2), id: \.id) { event in
                    ZStack(alignment: .leading) {
                        Rectangle()
                            .fill(Color.customGreen.opacity(0.8))
                            .cornerRadius(geometry.size.width * 0.01)
                            .frame(width: geometry.size.width * 0.13, height: geometry.size.height * 0.024)
                        
                        Text(event.title)
                            .font(.regular8)
                            .lineLimit(1)
                            .padding(.leading, geometry.size.width * 0.005)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                
                // 만약 일정이 1개라면 빈 공간 추가
                if dayEvents.count == 1 {
                    Text(" ")
                        .font(.regular8)
                        .frame(width: geometry.size.width * 0.13, height: geometry.size.height * 0.024)
                        .padding(.leading, geometry.size.width * 0.005)
                        .opacity(0)
                }
            }
        }
}

#Preview {
    HealthCalendarView()
}
