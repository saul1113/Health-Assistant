//
//  HomeView.swift
//  Health-Assistant
//
//  Created by Hwang_Inyoung on 11/1/24.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var dataManager: DataManager = DataManager()
    @StateObject private var viewModel = CalenderViewModel()
    @StateObject private var healthData: HealthDataManager = HealthDataManager()
    @StateObject private var locationManager: LocationManager = LocationManager()
    @StateObject private var userViewModel = UserViewModel()
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
                                MiniWeekView(viewModel: CalenderViewModel())
                                    .background(.white, in: RoundedRectangle(cornerRadius: 20))
                            }
                            chartView(geometry: proxy)
                                .frame(height: 180)
                            healthDataView()
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 20)
                        .scrollIndicators(.hidden)
                        .background(Color.CustomGreen02)
                        .cornerRadius(15, corners: [.topLeft, .topRight])
                    }
                    .onAppear {
                        
                        locationManager.fetchAddress { local in
                            Task {
                                await userViewModel.fetchHospitalLocation(local: local)
                                try? await dataManager.signUp()
                                await locationManager.fetchAddressFromLocation(hospitalAddress: userViewModel.hospitalsInfo)
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
