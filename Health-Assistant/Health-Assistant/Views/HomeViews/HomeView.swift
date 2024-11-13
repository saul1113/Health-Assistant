//
//  HomeView.swift
//  Health-Assistant
//
//  Created by Hwang_Inyoung on 11/1/24.
//

import SwiftUI
import Charts

struct HomeView: View {
    @StateObject private var dataManager: DataManager = DataManager()
    @StateObject private var viewModel = CalenderViewModel()
    @StateObject private var healthData: HealthDataManager = HealthDataManager()
    @StateObject private var locationManager: LocationManager = LocationManager()
    @StateObject private var userViewModel = UserViewModel()
    @StateObject private var viewModelHeart = HeartRateViewModel()
    @StateObject private var sleepViewModel = SleepDataViewModel()
    @State private var heartRate: Double = 0
    
    private var sortedHospitals: [(String, Double, String)] {
        // 병원 이름, 거리, 주소를 묶어서 배열을 생성하고 거리 기준으로 정렬
        let hospitals = (0..<locationManager.hospitalNames.count).map { index in
            (locationManager.hospitalNames[index],
             locationManager.hospitalDistances[index],
             locationManager.hospitalAddresses[index])
        }
        
        return hospitals.sorted { $0.1 < $1.1 }  // 거리 기준으로 정렬
    }
    
    let nickname: String = "강사"
    var body: some View {
        NavigationStack {
            GeometryReader { proxy in
                ZStack (alignment: .bottom){
                    Color.customGreen
                        .ignoresSafeArea(edges: .top)
                    VStack (alignment: .leading) {
                        Spacer()
                            .frame(height: 20)
                        Text("안녕하세요 \(nickname)님!")
                            .font(.bold30)
                            .padding(.horizontal, 16)
                        Text("꾸준한 관리가 건강을 지키는 가장 큰 비결입니다. 오늘도 작은 변화를 시작해보세요!")
                            .font(.medium14)
                            .padding(.horizontal, 16)
                        Spacer()
                            .frame(height: 80)
                        ScrollView {
                            NavigationLink {
                                HealthCalendarView()
                            } label: {
                                MiniWeekView(viewModel: viewModel)
                                    .background(.white, in: RoundedRectangle(cornerRadius: 20))
                            }
                            chartView(geometry: proxy)
                                .frame(height: 180)
                            
                            NavigationLink(destination: HeartRateChartView()) {
                                healthDataView()
                            }
                            
                            NavigationLink(destination: SleepChartView()) {
                                sleepTime(geometry: proxy)
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 20)
                        .scrollIndicators(.hidden)
                        .background(Color.CustomGreen02)
                        .cornerRadius(15, corners: [.topLeft, .topRight])
                        .padding(.bottom, 50)
                    }
                    .onAppear {
                        locationManager.fetchAddress { local in
                            Task {
                                await userViewModel.fetchHospitalLocation(local: local) { items in
                                    Task {
                                        await locationManager.fetchAddressFromLocation(hospitalAddress: items)
                                    }
                                }
//                                try? await dataManager.signUp()
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
            HStack {
                // 6시간 차트 표시
                Chart(viewModelHeart.filteredData.filter { item in
                    Calendar.current.isDateInToday(item.date) // 6시간 범위 데이터 필터링
                }) { item in
                    PointMark(
                        x: .value("Time", item.date),
                        y: .value("Heart Rate", item.value)
                    )
                    .foregroundStyle(.red)
                    .symbolSize(50)
                }
                .padding(.horizontal)
                VStack {
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
        HStack(spacing: 10) {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .frame(maxWidth: geometry.size.width / 2, maxHeight: geometry.size.height / 4)
            
            NavigationLink {
                HospitalMapView(hospitals: userViewModel.hospitalsInfo)
            } label: {
                VStack(alignment: .leading, spacing: 10) {
                    Text("내 근처 병원")
                        .font(.bold18)
                        .foregroundColor(.black)
                        .padding(.leading, 10)
                    
                    ForEach(0..<min(3, sortedHospitals.count), id: \.self) { index in
                        let hospital = sortedHospitals[index].0
                        let distance = sortedHospitals[index].1
                        let address = sortedHospitals[index].2
                        
                        HStack(alignment: .top, spacing: 8) {
                          
                            Divider()
                                .frame(width: 2, height: 26)
                                .background(Color.CustomGreen)
                            
                            VStack(alignment: .leading, spacing: 3) {
                                
                                HStack {
                                    Text(hospital)
                                        .font(.semibold14)
                                        .foregroundColor(.black)
                                        
                                    Spacer()
                                    
                                    Text("\(Int(distance)/1000)km")
                                        .font(.regular10)
                                        .foregroundColor(.CustomGreen)
                                }
                                
                                Text(address)
                                    .font(.regular10)
                                    .foregroundColor(.gray)
                                    .lineLimit(0)
                            }
                        }
                        .padding(.horizontal, 8)
                    }
                }
                .padding(12)
                .frame(maxWidth: geometry.size.width / 2, maxHeight: geometry.size.height / 4)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                )
            }
        }
    }




    
    func sleepTime(geometry: GeometryProxy) -> some View {
        VStack(spacing: 5) {
            
            // 수면 데이터 차트 표시
            Chart(sleepViewModel.filteredSleepData()) { stage in
                RectangleMark(
                    xStart: .value("Start Time", stage.startDate),
                    xEnd: .value("End Time", stage.endDate),
                    y: .value("Stage", stage.stage.rawValue)
                )
                .foregroundStyle(stage.stage.color)
            }
//            .frame(height: 100)
            .padding(.horizontal)
            
            HStack {
                Text("수면시간")
                    .foregroundStyle(.gray)
                    .font(.medium14)
                
                Spacer()
                
                Text("\(sleepViewModel.formattedTotalSleepDuration())")
                    .font(.bold16)
                    .foregroundStyle(.black)
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
        )
        .padding(.top, -20)
    }
}


#Preview {
    HomeView()
}
