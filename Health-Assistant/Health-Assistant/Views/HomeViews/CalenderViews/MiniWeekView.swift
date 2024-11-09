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
            
            HStack {
                ForEach(viewModel.currentWeekDates(), id: \.self) { date in
                    VStack {
                        Text(viewModel.formattedDayOfWeek(date))
                            .font(.regular14)
                            .padding(.vertical, -5)
                            .foregroundColor(.black)
                        
                        Text(viewModel.formattedDayOfMonth(date))
                            .font(.headline)
                            .foregroundColor(viewModel.isToday(date) ? .white : .primary)
                            .padding(8)
                            .background(viewModel.isToday(date) ? Color.blue.opacity(0.4) : Color.clear)
                            .clipShape(Circle())
                        
                        Spacer()
                        
                        let dayEvents = viewModel.events(for: date, context: modelContext)
                        ForEach(dayEvents.prefix(2), id: \.id) { event in
                            Text(event.title)
                                .font(.caption)
                                .lineLimit(1)
                                .padding(4)
                                .background(Color.customGreen.opacity(0.8))
                                .cornerRadius(4)
                                .foregroundColor(.white)
                        }
                        
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
        .background(Color.white)
        .cornerRadius(20)
    }
}

extension CalenderViewModel {
    func formattedDayOfWeek(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "E"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: date)
    }
    
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
