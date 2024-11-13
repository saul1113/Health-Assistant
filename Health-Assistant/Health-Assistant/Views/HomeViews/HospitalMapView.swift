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
    @State private var cameraPosition: MapCameraPosition = .region (
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 37.5665, longitude: 126.978),
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        )
        
    )
    let hospitals: [Item]
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                Map(position: $cameraPosition){
                    ForEach(locationManager.hospitalLocation.indices, id: \.self) { index in
                        Annotation("", coordinate: locationManager.hospitalLocation[index]){
                            ZStack {
                                Image("HospitalMarker")
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
                                .font(.bold18)
                        }
                        .padding()
                    }
                    
                    HospitalListView(hospitals: hospitals, currentLocation: locationManager.hospitalDistances, hospitalLocation: locationManager.hospitalLocation, cameraPosition: $cameraPosition, isSheetExpanded: $isSheetExpanded)
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
    let hospitalLocation: [CLLocationCoordinate2D]
    @Binding var cameraPosition: MapCameraPosition
    @Binding var isSheetExpanded: Bool
    var body: some View {
        VStack {
            HStack {
                Text("병원 목록")
                    .font(.bold28)
                Spacer()
            }
            .padding(.horizontal)
            .padding(.top, 10)
            
            // 3개의 배열을 zip으로 묶기
            let sortedHospitals = zip(hospitals, zip(currentLocation, hospitalLocation))
                .sorted { $0.1.0 < $1.1.0 } // 거리순 정렬
            
            List(sortedHospitals.indices, id: \.self) { index in
                HStack {
                    VStack(alignment: .leading, spacing: 5) {
                        // 병원 이름과 주소 표시
                        Text(sortedHospitals[index].0.dutyName ?? "")
                            .font(.semibold18)
                        Text(sortedHospitals[index].0.dutyAddr ?? "")
                        
                        // 거리 표시
                        if currentLocation.indices.contains(index) {
                            if sortedHospitals[index].1.0 > 1000 {
                                Text("거리: \(Int(sortedHospitals[index].1.0 / 1000)) Km")
                                    .font(.regular14)
                                    .foregroundStyle(.customGreen)
                            } else {
                                Text("거리: \(Int(sortedHospitals[index].1.0)) m")
                                    .font(.regular14)
                                    .foregroundStyle(.customGreen)
                            }
                        }
                    }
                    Spacer()
                }
                .padding(.vertical, 5)
                .onTapGesture {
                    let coordinate = sortedHospitals[index].1.1
                    withAnimation {
                        cameraPosition = .region(
                            MKCoordinateRegion(
                                center: CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude),
                                span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                            )
                        )
                    }
                    isSheetExpanded = false
                }
            }
            .listStyle(PlainListStyle())
        }
        .padding(.top)
    }
}
