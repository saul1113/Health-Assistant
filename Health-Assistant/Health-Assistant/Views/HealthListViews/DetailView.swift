//
//  DetailView.swift
//  Health-Assistant
//
//  Created by wonhoKim on 11/4/24.
//

//디테일뷰 더미

import SwiftUI

struct DetailView: View {
    var report: HealthReport
    
    var body: some View {
        VStack {
            Text(report.title)
                .font(.largeTitle)
                .padding()
            
            Text(report.dateRange)
                .font(.title2)
                .foregroundColor(.gray)
            
            Spacer()
        }
        .navigationTitle(report.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}
