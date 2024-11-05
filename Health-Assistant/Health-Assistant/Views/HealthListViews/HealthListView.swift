//
//  HealthListView.swift
//  Health-Assistant
//
//  Created by Hwang_Inyoung on 11/1/24.
//

import SwiftUI

struct HealthListView: View {
    @State private var selectedTab = 0
    @State private var isPresentingNewReportView = false
    @State private var ocrRecords: [HealthReport] = []
    @State private var healthReports: [HealthReport] = []
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Picker("", selection: $selectedTab) {
                    Text("OCR 기록").tag(0)
                    Text("건강 리포트").tag(1)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
                
                
                
                let selectedRecords = selectedTab == 0 ? ocrRecords : healthReports
                
                if selectedRecords.isEmpty {
                    
                    Text("기록이 없습니다.")
                        .foregroundColor(.gray)
                        .font(.bold16)
                        .padding()
                } else {
                    List {
                        ForEach(selectedRecords) { report in
                            NavigationLink(destination: ReportsDetailView(report: report)) {
                                HealthReportItem(title: report.title, dateRange: report.dateRange)
                                    .listRowInsets(EdgeInsets())
                            }
                        }
                    }
                    .listStyle(PlainListStyle())
                }
                
                Spacer()
            }
            .navigationTitle("건강기록")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        if selectedTab == 0 {
                          //OCR 추가하는 로직이 와야함
                        } else {
                            // 건강리포트 쪽
                            isPresentingNewReportView = true
                        }
                    }) {
                        Image(systemName: "plus")
                            .font(.regular20)
                    }
                }
            }
            .sheet(isPresented: $isPresentingNewReportView) {
                NewReportView { newReport in
                    healthReports.append(newReport)
                }
            }
        }
    }
}

struct HealthReportItem: View {
    var title: String
    var dateRange: String
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(title)
                    .font(.headline)
                
                Text(dateRange)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Spacer()
        }
        .padding()
        .background(Color.green.opacity(0.3))
        .cornerRadius(10)
    }
}

#Preview {
    HealthListView()
}
