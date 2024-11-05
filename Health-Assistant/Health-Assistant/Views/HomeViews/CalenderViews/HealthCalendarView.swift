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
    
    var body: some View {
        VStack {
            // 월/년도 선택과 이전/다음 달 이동 버튼
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
                        .bold()
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
                
            }
            .padding()
            
            Spacer()
            
            // 요일 표시 (일월화수목금토 순서)
            HStack {
                ForEach(["일", "월", "화", "수", "목", "금", "토"], id: \.self) { day in
                    Text(day)
                        .frame(maxWidth: .infinity)
                        .font(.medium18)
                }
            }
            .padding(.horizontal)
            
            // 날짜 및 이벤트 미리보기 표시 (월의 일 수와 시작 요일에 맞춰 동적 생성)
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 10) {
                ForEach(0..<viewModel.startDayOffset() + viewModel.daysInCurrentMonth(), id: \.self) { index in
                    if index < viewModel.startDayOffset() {
                        // 빈 칸 표시
                        Text(" ")
                            .frame(height: 50)
                    } else {
                        let day = index - viewModel.startDayOffset() + 1
                        VStack(alignment: .center, spacing: 5) {
                            Text("\(day)")
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding(8)
                                .background(day == viewModel.todayDay && viewModel.isCurrentMonthAndYear() ? Color.blue.opacity(0.3) : (day == viewModel.selectedDay ? Color.green.opacity(0.3) : Color.clear))
                                .clipShape(Circle())
                                .font(.semibold18)
                            
                            Spacer()
                            
                            // 이벤트 제목 표시 (최대 2개)
                            ForEach(viewModel.events(for: day).prefix(2), id: \.id) { event in
                                Text(event.title)
                                    .font(.regular16)
                                    .lineLimit(1)
                                    .truncationMode(.tail)
                                    .padding(1)
                                    .background(Color.CustomGreen.opacity(0.8))
                                    .foregroundStyle(.white)
                                    .cornerRadius(5)
                            }
                        }
                        .frame(height: 110)
                        .cornerRadius(5)
                        .onTapGesture {
                            viewModel.selectedDay = day
                            showDayEvents = true
                        }
                    }
                }
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .sheet(isPresented: $showDayEvents) {
            if let selectedDay = viewModel.selectedDay {
                DayEventsView(viewModel: viewModel, day: selectedDay)
                    .presentationDetents([.large]) // 풀스크린으로 띄움
            }
        }
    }
}

#Preview {
    HealthCalendarView()
}
