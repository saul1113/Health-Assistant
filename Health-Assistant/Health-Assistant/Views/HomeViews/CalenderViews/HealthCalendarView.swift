//
//  HealthCalendarView.swift
//  Health-Assistant
//
//  Created by Hwang_Inyoung on 11/4/24.
//

import SwiftUI

struct HealthCalendarView: View {
    @ObservedObject var viewModel = CalendarViewModel()
    @State private var selectedDay: Int?
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
                        .font(.title)
                        .bold()
                }
                
                Spacer()
                
                Button(action: { viewModel.moveToPreviousMonth() }) {
                    Image(systemName: "chevron.left")
                }
                
                Button(action: { viewModel.moveToNextMonth() }) {
                    Image(systemName: "chevron.right")
                }
            }
            .padding()
            
            // 요일 표시
            HStack {
                ForEach(["월", "화", "수", "목", "금", "토", "일"], id: \.self) { day in
                    Text(day)
                        .frame(maxWidth: .infinity)
                        .font(.subheadline)
                }
            }
            
            // 날짜 및 이벤트 미리보기 표시
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 10) {
                ForEach(1...31, id: \.self) { day in
                    VStack(alignment: .leading, spacing: 5) {
                        Text("\(day)")
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        // 이벤트 제목 표시 (최대 2개)
                        ForEach(viewModel.events(for: day).prefix(2), id: \.id) { event in
                            Text(event.title)
                                .font(.caption)
                                .lineLimit(1)
                                .truncationMode(.tail)
                        }
                    }
                    .frame(height: 50)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(5)
                    .onTapGesture {
                        selectedDay = day
                        showDayEvents = true
                    }
                }
            }
            .padding()
        }
        .sheet(isPresented: $showDayEvents) {
            if let day = selectedDay {
                DayEventsView(viewModel: viewModel, day: day)
            }
        }
    }
}

#Preview {
    HealthCalendarView()
}
