//
//  HospitalMapView.swift
//  Health-Assistant
//
//  Created by Soom on 11/5/24.
//

import SwiftUI

struct HospitalMapView: View {
    @StateObject private var locationManager = LocationManager()
    let hospitals: [Item]
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    ForEach(hospitals, id: \.dutyName) { hospital in
                        if let hospitalName = hospital.dutyName, let hospitalAddress = hospital.dutyAddr {
                            NavigationLink {
                                MapView(locationName: hospitalName, location: hospitalAddress)
                            }label: {
                                hospitalView(hospitalName: hospitalName, hospitalAddress: hospitalAddress)
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, 16)
            .navigationTitle("가까운 병원 및 응급실 정보")
        }
    }
    func hospitalView(hospitalName: String, hospitalAddress: String)-> some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(hospitalName)
                .font(.bold18)
            Text(hospitalAddress)
                .font(.medium16)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 10)
        .padding(.vertical,5)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.CustomGreen02)
        )
    }
}


#Preview {
    HospitalMapView(hospitals: [])
}
