//
//  MiniWeekView.swift
//  Health-Assistant
//
//  Created by Hwang_Inyoung on 11/5/24.
//

import SwiftUI

struct MiniWeekView: View {
    @Environment(\.modelContext) private var modelContext
    @ObservedObject var viewModel: CalenderViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            // 이번 주 월 표시
            Text(viewModel.displayedMonthYear)
                .font(.bold28)
                .padding(.leading)
                .foregroundStyle(.black)
            
            HStack {
                ForEach(viewModel.currentWeekDates(), id: \.self) { date in
                    VStack() {
                        // 요일 표시
                        Text(viewModel.formattedDayOfWeek(date))
                            .font(.regular14)
                            .padding(.vertical, -5)
                            .foregroundStyle(.black)
                        
                        // 날짜 표시
                        Text(viewModel.formattedDayOfMonth(date))
                            .font(.headline)
                            .foregroundColor(viewModel.isToday(date) ? .white : .primary)
                            .padding(8)
                            .background(viewModel.isToday(date) ? Color.blue.opacity(0.4) : Color.clear)
                            .clipShape(Circle())
                        
                        Spacer()
                        
                        // 이벤트 표시 (최대 2개)
                        let dayEvents = viewModel.events(for: date, context: modelContext)
                        ForEach(dayEvents.prefix(2), id: \.id) { event in
                            Text(event.title)
                                .font(.caption)
                                .lineLimit(1)
                                .padding(4)
                                .background(Color.green.opacity(0.8))
                                .cornerRadius(4)
                                .foregroundColor(.white)
                        }
                        
                        // 더 많은 이벤트가 있을 경우 "+N"으로 표시
                        if dayEvents.count > 2 {
                            Text("+\(dayEvents.count - 2) 더보기")
                                .font(.caption2)
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.vertical, 2)
                    .frame(maxWidth: .infinity)
                }
            }
            .padding(.horizontal)
        }
        .frame(maxHeight: 140)
        .padding(.vertical)
        .background(.white)
//        .background(Color("CustomGreen").opacity(0.3))
        .cornerRadius(20)
    }
}

// CalendarViewModel에 요일과 날짜 포맷팅 메서드 추가
extension CalenderViewModel {
    // 요일 포맷 (예: "월")
    func formattedDayOfWeek(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "E"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: date)
    }
    
    // 날짜 포맷 (예: "5")
    func formattedDayOfMonth(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: date)
    }
}

struct MiniWeekView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = CalenderViewModel()
        
        // 샘플 이벤트를 추가
        let sampleEvents = [
            CalendarEvent(title: "Meeting", startTime: Date(), endTime: Date().addingTimeInterval(3600), isAllDay: false, alert: .none, notes: "Sample meeting event."),
            CalendarEvent(title: "Workout", startTime: Date(), endTime: Date().addingTimeInterval(90000), isAllDay: false, alert: .none, notes: "Sample workout event."),
            CalendarEvent(title: "Lunch", startTime: Date().addingTimeInterval(2 * 86400), endTime: Date().addingTimeInterval(2 * 86400 + 3600), isAllDay: false, alert: .none, notes: "Sample lunch event.")
        ]
        
        // 이벤트를 뷰모델에 추가
        viewModel.calendarEvents = sampleEvents
        
        return MiniWeekView(viewModel: viewModel)
            .previewLayout(.sizeThatFits)
    }
}
