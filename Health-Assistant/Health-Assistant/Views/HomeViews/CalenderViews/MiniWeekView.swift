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
            Text(viewModel.displayedMonthYear)
                .font(.bold28)
                .padding(.leading)
                .foregroundColor(.black)
            
            DayHeadersView()
                .padding(.horizontal)
            
            HStack {
                ForEach(viewModel.currentWeekDates(), id: \.self) { date in
                    VStack {
                        Text(viewModel.formattedDayOfMonth(date))
                            .font(.semibold16)  // 날짜 텍스트에 커스텀 세미볼드 적용
                            .foregroundColor(viewModel.isToday(date) ? .white : .primary)
                            .padding(8)
                            .background(viewModel.isToday(date) ? Color.blue.opacity(0.4) : Color.clear)
                            .clipShape(Circle())
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .padding(.horizontal)
            
            HStack {
                ForEach(viewModel.currentWeekDates(), id: \.self) { date in
                    VStack(alignment: .leading, spacing: 2) {
                        let dayEvents = viewModel.events(for: date, context: modelContext)
                        
                        ForEach(dayEvents.prefix(2), id: \.id) { event in
                            ZStack(alignment: .leading) {
                                Rectangle()
                                    .fill(Color.customGreen.opacity(0.8))
                                    .cornerRadius(4)
                                    .frame(width: 60, height: 20)
                                
                                Text(event.title)
                                    .font(.regular8)
                                    .lineLimit(1)
                                    .padding(.leading, 5)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                        
                        if dayEvents.count == 1 {
                            Text(" ")
                                .font(.regular8)
                                .padding(4)
                        }
                        
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .frame(maxHeight: 140)
        .padding(.vertical)
        .background(Color.white)
        .cornerRadius(20)
        .onAppear {
            viewModel.loadEvents(context: modelContext)
        }
    }
}

extension CalenderViewModel {
    func formattedDayOfMonth(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: date)
    }
}

struct MiniWeekView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = CalenderViewModel()
        
        let sampleEvents = [
            CalendarEvent(title: "Meeting", startTime: Date(), endTime: Date().addingTimeInterval(3600), isAllDay: false, alert: .none, notes: "Sample meeting event."),
            CalendarEvent(title: "Workout", startTime: Date(), endTime: Date().addingTimeInterval(90000), isAllDay: false, alert: .none, notes: "Sample workout event."),
            CalendarEvent(title: "Lunch", startTime: Date().addingTimeInterval(2 * 86400), endTime: Date().addingTimeInterval(2 * 86400 + 3600), isAllDay: false, alert: .none, notes: "Sample lunch event.")
        ]
        
        viewModel.calendarEvents = sampleEvents
        
        return MiniWeekView(viewModel: viewModel)
            .previewLayout(.sizeThatFits)
    }
}
