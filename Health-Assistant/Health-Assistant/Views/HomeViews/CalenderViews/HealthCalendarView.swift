//
//  HealthCalendarView.swift
//  Health-Assistant
//
//  Created by Hwang_Inyoung on 11/4/24.
//

import SwiftUI

struct HealthCalendarView: View {
    @ObservedObject var viewModel = CalendarViewModel()
    @State private var showDayEvents = false
    @State private var showAddEvent = false
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
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
                
                Spacer()
                
                HStack {
                    ForEach(["일", "월", "화", "수", "목", "금", "토"], id: \.self) { day in
                        Text(day)
                            .frame(maxWidth: .infinity)
                            .font(.medium18)
                    }
                }
                .padding(.horizontal)
                
                // 날짜 및 이벤트 미리보기 표시
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: geometry.size.height * 0.01) {
                    ForEach(0..<viewModel.startDayOffset() + viewModel.daysInCurrentMonth(), id: \.self) { index in
                        if index < viewModel.startDayOffset() {
                            Text(" ")
                                .frame(height: geometry.size.height * 0.06)
                        } else {
                            let day = index - viewModel.startDayOffset() + 1
                            
                            ZStack {
                                // 날짜 숫자 (고정 위치)
                                VStack {
                                    Text("\(day)")
                                        .padding(geometry.size.width * 0.015)
                                        .frame(maxWidth: .infinity)
                                        .background(day == viewModel.todayDay && viewModel.isCurrentMonthAndYear() ? Color.blue.opacity(0.3) : (day == viewModel.selectedDay ? Color.green.opacity(0.3) : Color.clear))
                                        .clipShape(Circle())
                                        .font(.semibold18)
                                    
                                    Spacer() // 날짜 숫자와 이벤트 목록 사이에 공간 추가
                                }
                                
                                VStack(spacing: geometry.size.height * 0.005) {
                                    Spacer() // 일정 목록을 날짜 숫자 아래로 밀기 위해 Spacer 사용
                                    
                                    if viewModel.events(for: day).isEmpty {
                                        // 일정이 없을 때 빈 공간 2개 추가
                                        Text(" ")
                                            .font(.regular16)
                                            .padding(geometry.size.width * 0.005)
                                            .opacity(0) // 보이지 않게 설정하여 일정이 없을 때의 공간을 확보
                                        Text(" ")
                                            .font(.regular16)
                                            .padding(geometry.size.width * 0.005)
                                            .opacity(0)
                                    } else if viewModel.events(for: day).count == 1 {
                                        ForEach(viewModel.events(for: day).prefix(1), id: \.id) { event in
                                            Text(event.title)
                                                .font(.regular16)
                                                .lineLimit(1)
                                                .truncationMode(.tail)
                                                .padding(geometry.size.width * 0.005)
                                                .background(Color.customGreen.opacity(0.8))
                                                .foregroundColor(.white)
                                                .cornerRadius(geometry.size.width * 0.01)
                                        }
                                        // 일정이 1개일 때는 빈 공간 1개와 일정 텍스트 1개 추가
                                        Text(" ")
                                            .font(.regular16)
                                            .padding(geometry.size.width * 0.005)
                                            .opacity(0) // 빈 공간 하나 추가
                                    } else {
                                        // 일정이 2개 이상일 때
                                        ForEach(viewModel.events(for: day).prefix(2), id: \.id) { event in
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
                                .padding(.top, geometry.size.height * 0.04) // 일정 목록을 날짜 아래에 배치하도록 추가 간격 설정
                            }
                            .frame(height: geometry.size.height * 0.12)
                            .onTapGesture {
                                viewModel.selectedDay = day
                                showDayEvents = true
                            }
                        }
                    }
                    Spacer()
                }
                .padding()
                .sheet(isPresented: $showDayEvents) {
                    if let selectedDay = viewModel.selectedDay {
                        DayEventsView(viewModel: viewModel, day: selectedDay)
                            .presentationDetents([.large]) // Full screen
                    }
                }
                
                Spacer()
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity) // Expand to full screen
            .sheet(isPresented: $showAddEvent) {
                AddEventView(viewModel: viewModel)
            }
        }
    }
}

#Preview {
    HealthCalendarView()
}
