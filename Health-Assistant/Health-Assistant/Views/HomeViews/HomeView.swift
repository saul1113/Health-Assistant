//
//  HomeView.swift
//  Health-Assistant
//
//  Created by Hwang_Inyoung on 11/1/24.
//

import SwiftUI


struct HomeView: View {
    @StateObject private var healthData: HealthDataManager = HealthDataManager()
    @StateObject private var locationManager: LocationManager = LocationManager()
    @StateObject private var userViewModel = UserViewModel()
    @State private var heartRate: Double = 0
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ZStack {
                    Color.CustomGreen
                        .ignoresSafeArea()
                        .overlay (alignment: .bottom){
                            RoundedRectangle(cornerRadius: 20)
                                .fill(.white)
                                .frame(height: geometry.size.height / 1.6)
                        }
                        .ignoresSafeArea()
                    VStack(spacing: 55) {
                        
                        healthDataView()
                        
                        sleepTime(geometry: geometry)
                        
                        chartView(geometry: geometry)
                        
                        NavigationLink(destination: HealthCalendarView()) {
                            MiniWeekView(viewModel: CalendarViewModel())
                        }
                        
                                            }
                    .onAppear {
                        locationManager.fetchAddress { local, locality in
                            Task {
                                await userViewModel.fetchHospitalLocation(local: local, locality: locality)
                            }
                        }
                    }
                    .toolbar {
                        ToolbarItem(placement: .topBarLeading) {
                            Image(.hahaTitleWhite)
                        }
                        ToolbarItem(placement: .topBarTrailing) {
                            Image(systemName: "bell.fill")
                                .foregroundStyle(.white)
                        }
                    }
                }
            }
        }
    }
    func healthDataView() -> some View {
        VStack {
            Text("현재")
            if healthData.isMeasuring {
                Text("0")
                    .foregroundStyle(.white)
                    .font(.bold96)
                    .padding(.vertical, 0)
            }
            else {
                Text("\(String(format: "%.f", healthData.heartRate))")
                    .foregroundStyle(.white)
                    .font(.bold96)
                    .padding(.vertical, -27)
                
            }
            HStack {
                Text("BPM")
                    .foregroundStyle(.white)
                    .font(.regular20)
                Image(systemName: "heart.fill")
                    .foregroundStyle(.white)
            }
        }
    }
    func chartView(geometry: GeometryProxy) -> some View {
        HStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.customGreen30)
                .frame(maxWidth: geometry.size.width / 2, maxHeight: geometry.size.height / 4)
            NavigationLink {
                HospitalMapView(hospitals: userViewModel.hospitalsInfo)
            }label: {
                Text("\(locationManager.currentAddress ?? "")")
                    .frame(maxWidth: geometry.size.width / 2, maxHeight: geometry.size.height / 4)
                    .background {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.customGreen30)
                    }
                
            }
        }
        .padding(.horizontal, 20)
    }
    
    func sleepTime(geometry: GeometryProxy) -> some View {
        VStack(spacing: 5) {
            let gaugeSize = geometry.size.width - 94
            let gaugePerOne = gaugeSize / 10
            Text("2024.11.03")
                .foregroundStyle(.gray)
                .font(.medium14)
                .frame(maxWidth: geometry.size.width, alignment: .leading)
            RoundedRectangle(cornerRadius: 18)
                .fill(Color.green)
                .frame(width: abs(geometry.size.width - 94), height: 34)
                .overlay (alignment: .leading) {
                    RoundedRectangle(cornerRadius: 18)
                        .frame(width:abs(gaugePerOne * 5) )
                        .foregroundStyle(.white)
                }
            HStack {
                Text("수면시간")
                    .foregroundStyle(.gray)
                    .font(.medium14)
                Text("6시간 33분")
                    .font(.bold16)
                    .foregroundStyle(.white)
                Spacer()
                Text("취침 시간")
                    .foregroundStyle(.gray)
                    .font(.medium14)
                Text("7시간 47분")
                    .font(.bold16)
            }
        }
        .padding(.horizontal, 47)
    }
}


#Preview {
    HomeView()
}
