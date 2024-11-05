//
//  HomeView.swift
//  Health-Assistant
//
//  Created by Hwang_Inyoung on 11/1/24.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = CalendarViewModel()

    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: HealthCalendarView(viewModel: viewModel)) {
                    MiniWeekView(viewModel: viewModel)
                        .padding()
                        .cornerRadius(8)
                }
                
                Spacer()
            }
        }
    }
}


#Preview {
    HomeView()
}
