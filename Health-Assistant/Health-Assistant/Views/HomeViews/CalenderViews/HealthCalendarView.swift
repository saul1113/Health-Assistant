//
//  HealthCalendarView.swift
//  Health-Assistant
//
//  Created by Hwang_Inyoung on 11/4/24.
//

import SwiftUI

struct HealthCalendarView: View {
    @Environment(\.modelContext) private var modelContext
    @ObservedObject var viewModel = CalendarViewModel()
    @State private var showDayEvents = false
    @State private var showAddEvent = false
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                headerView(geometry: geometry)
                
                Spacer()
                
                dayHeaders(geometry: geometry)
                
                dateGridView(geometry: geometry)
                
                Spacer()
            }
            .sheet(isPresented: $showAddEvent) {
                AddEventView(viewModel: viewModel)
            }
            .sheet(isPresented: $showDayEvents) {
                if let selectedDay = viewModel.selectedDay {
                    DayEventsView(viewModel: viewModel, day: selectedDay)
                        .presentationDetents([.large]) // Full screen
                }
            }
        }
    }
    
    private func headerView(geometry: GeometryProxy) -> some View {
        HStack {
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
            
            Spacer()
            
            Button(action: { viewModel.moveToPreviousMonth() }) {
                Image(systemName: "chevron.left")
                    .font(.bold24)
            }
            
            Button(action: { viewModel.moveToNextMonth() }) {
                Image(systemName: "chevron.right")
                    .font(.bold24)
            }
            
            Button(action: {
                showAddEvent = true
            }) {
                Image(systemName: "plus.circle.fill")
                    .font(.bold24)
                    .foregroundColor(.green)
            }
            .padding(.leading)
        }
        .padding(.horizontal)
        .padding(.top, geometry.size.height * 0.02)
    }
    
    private func dayHeaders(geometry: GeometryProxy) -> some View {
        HStack {
            ForEach(["일", "월", "화", "수", "목", "금", "토"], id: \.self) { day in
                Text(day)
                    .frame(maxWidth: .infinity)
                    .font(.medium18)
            }
        }
        .padding(.horizontal)
    }
    
    private func dateGridView(geometry: GeometryProxy) -> some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: geometry.size.height * 0.01) {
            ForEach(0..<viewModel.startDayOffset() + viewModel.daysInCurrentMonth(), id: \.self) { index in
                if index < viewModel.startDayOffset() {
                    Text(" ")
                        .frame(height: geometry.size.height * 0.06)
                } else {
                    let day = index - viewModel.startDayOffset() + 1
                    DayCellView(day: day, geometry: geometry, viewModel: viewModel)
                        .onTapGesture {
                            viewModel.selectedDay = day
                            showDayEvents = true
                        }
                }
            }
            Spacer()
        }
        .padding()
    }
}

struct DayCellView: View {
    @Environment(\.modelContext) private var modelContext
    let day: Int
    let geometry: GeometryProxy
    let viewModel: CalendarViewModel
    
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
            
            VStack(spacing: geometry.size.height * 0.005) {
                Spacer()
                
                let events = viewModel.events(for: day, context: modelContext)
                
                if events.isEmpty {
                    // 일정이 없는 경우 빈 텍스트 두 개 추가
                    emptyEventPlaceholders()
                    emptyEventPlaceholders()
                } else if events.count == 1 {
                    // 일정이 한 개만 있는 경우 일정 한 개와 빈 텍스트 한 개 추가
                    eventTexts()
                    emptyEventPlaceholders()
                } else {
                    // 일정이 두 개 이상인 경우 두 개만 표시
                    eventTexts()
                }
            }
            .padding(.top, geometry.size.height * 0.04)
        }
        .frame(height: geometry.size.height * 0.12)
    }
    
    private func dayBackgroundColor() -> Color {
        if day == viewModel.todayDay && viewModel.isCurrentMonthAndYear() {
            return Color.blue.opacity(0.3)
        } else if day == viewModel.selectedDay {
            return Color.green.opacity(0.3)
        } else {
            return Color.clear
        }
    }
    
    private func emptyEventPlaceholders() -> some View {
        VStack {
            Text(" ")
                .font(.regular16)
                .padding(geometry.size.width * 0.005)
                .opacity(0)
        }
    }
    
    private func eventTexts() -> some View {
        VStack(spacing: geometry.size.height * 0.002) {
            ForEach(viewModel.events(for: day, context: modelContext).prefix(2), id: \.id) { event in
                Text(event.title)
                    .font(.regular16)
                    .lineLimit(1)
                    .truncationMode(.tail)
                    .padding(geometry.size.width * 0.005)
                    .background(Color.customGreen.opacity(0.8))
                    .foregroundColor(.white)
                    .cornerRadius(geometry.size.width * 0.01)
            }
        }
    }
}

#Preview {
    HealthCalendarView()
}
