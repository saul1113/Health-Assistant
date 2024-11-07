//
//  HomeView.swift
//  Health-Assistant
//
//  Created by Hwang_Inyoung on 11/1/24.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var dataManager: DataManager = DataManager()
    @StateObject private var viewModel = CalendarViewModel()
    @StateObject private var healthData: HealthDataManager = HealthDataManager()
    @StateObject private var locationManager: LocationManager = LocationManager()
    @StateObject private var userViewModel = UserViewModel()
    @State private var heartRate: Double = 0
    
    let nickname: String = "강사"
    var body: some View {
        NavigationStack {
            GeometryReader { proxy in
                ZStack (alignment: .bottom){
                    Color.customGreen
                        .ignoresSafeArea(edges: .top)
                    RoundedRectangle(cornerRadius: 20)
                        .fill(.bar)
                        .frame(height: proxy.size.height / 1.3)
                        .ignoresSafeArea(edges: .bottom)
                    VStack (alignment: .leading) {
                        Spacer()
                            .frame(height: 20)
                        Text("안녕하세요 \(nickname)님!")
                            .font(.bold30)
                        Text("꾸준한 관리가 건강을 지키는 가장 큰 비결입니다. 오늘도 작은 변화를 시작해보세요!")
                            .font(.medium14)
                        Spacer()
                            .frame(height: 100)
                        ScrollView {
                            NavigationLink {
                                HealthCalendarView()
                            } label: {
                                MiniWeekView(viewModel: CalendarViewModel())
                                    .background(.white, in: RoundedRectangle(cornerRadius: 20))
                            }
                            chartView(geometry: proxy)
                                .frame(height: 180)
                            healthDataView()
                        }
                        .scrollIndicators(.hidden)
                    }
                    .padding(.horizontal, 20)
                    .onAppear {
                        locationManager.fetchAddress { local, locality in
                            Task {
                                await userViewModel.fetchHospitalLocation(local: local, locality: locality)
                                try? await dataManager.signUp()
                            }
                        }
                    }
                    .foregroundStyle(.white)
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
    func healthDataView() -> some View {
        VStack (alignment: .center, spacing: 0) {
            Text("현재")
            if healthData.isMeasuring {
                Text("0")
                    .font(.bold96)
                    .padding(.vertical, -17)
            }
            else {
                Text("\(String(format: "%.f", healthData.heartRate))")
                    .font(.bold96)
                    .padding(.vertical, -27)
            }
            HStack {
                Text("BPM")
                    .font(.regular20)
                Image(systemName: "heart.fill")
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .foregroundStyle(.black)
        .background(
            RoundedRectangle(cornerRadius: 20)
        )
        .padding(.bottom, 20)
    }
    func chartView(geometry: GeometryProxy) -> some View {
        HStack (spacing: 10) {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .frame(maxWidth: geometry.size.width / 2, maxHeight: geometry.size.height / 4)
            NavigationLink {
                HospitalMapView(hospitals: userViewModel.hospitalsInfo)
            } label: {
                Text("\(locationManager.currentAddress ?? "")\n 가까운 병원 및 응급실")
                    .frame(maxWidth: geometry.size.width / 2, maxHeight: geometry.size.height / 4)
                    .foregroundStyle(.black)
                    .background {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.white)
                    }
                
            }
        }
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
