//
//  HospitalMapView.swift
//  Health-Assistant
//
//  Created by Soom on 11/5/24.
//
//현재 리스트를 누르면 맵뷰로 넘
import SwiftUI
import MapKit
struct HospitalMapView: View {
    @StateObject private var locationManager = LocationManager()
    @State private var isSheetExpanded = false
    
    let hospitals: [Item]
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                Map {
                    ForEach(locationManager.hospitalLocation.indices, id: \.self) { index in
                        Annotation("\(index)", coordinate: locationManager.hospitalLocation[index]){
                            ZStack {
                                Text("🏥\(hospitals[index].dutyName ?? "") ")
                                    .background {
                                        Rectangle()
                                            .padding()
                                    }
                            }
                        }
                    }
                }
                .task {
                    await locationManager.fetchAddressFromLocation(hospitalAddress: hospitals)
                }
                .navigationTitle("가까운 병원 및 응급실 정보")
                
                VStack(spacing: 0) {
                    if !isSheetExpanded {
                        Button(action: {
                            withAnimation {
                                isSheetExpanded = true
                            }
                        }) {
                            Text("목록보기")
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.customGreen)
                                .cornerRadius(20)
                        }
                        .padding()
                    }
                    
                    HospitalListView(hospitals: hospitals, currentLocation: locationManager.hospitalDistances)
                        .frame(height: isSheetExpanded ? 500 : 160)
                        .background(Color.white)
                        .cornerRadius(20)
                        .shadow(radius: 10)
                        .gesture(
                            DragGesture().onEnded { value in
                                if value.translation.height > 50 {
                                    withAnimation {
                                        isSheetExpanded = false
                                    }
                                }
                            }
                        )
                }
            }
            .ignoresSafeArea(edges: .bottom)
        }
    }
}

struct HospitalListView: View {
    let hospitals: [Item]
    let currentLocation: [Double]
    
    var body: some View {
        VStack {
            HStack {
                Text("병원 목록")
                    .font(.bold28)
                Spacer()
            }
            .padding(.horizontal)
            .padding(.top, 10)
            //거리순 정렬
            let sortedHospitals = zip(hospitals, currentLocation).sorted { $0.1 < $1.1 }
            List(sortedHospitals.indices, id: \.self) { index in
                HStack {
                    VStack(alignment: .leading, spacing: 5) {
                        Text(sortedHospitals[index].0.dutyName ?? "")
                            .font(.semibold18)
                        if currentLocation.indices.contains(index) {
                            if sortedHospitals[index].1 > 1000 {
                                Text("거리: \(Int(sortedHospitals[index].1/1000)) Km")
                                    .font(.regular14)
                                    .foregroundStyle(.customGreen)
                            } else{
                                Text("거리: \(Int(sortedHospitals[index].1)) m")
                                    .font(.regular14)
                                    .foregroundStyle(.customGreen)
                                
                            }
                        }
                    }
                    Spacer()
                }
                .padding(.vertical, 5)
            }
            .listStyle(PlainListStyle())
        }
        .padding(.top)
    }
    
}

