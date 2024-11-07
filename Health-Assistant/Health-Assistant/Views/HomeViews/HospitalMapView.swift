//
//  HospitalMapView.swift
//  Health-Assistant
//
//  Created by Soom on 11/5/24.
//

import SwiftUI
import MapKit

struct HospitalMapView: View {
    let hospitals: [Item]
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    ForEach(hospitals, id: \.dutyName) { hospital in
                        hospitalView(hospital: hospital)
                    }
                }
            }
            .padding(.horizontal, 16)
            .navigationTitle("가까운 병원 및 응급실 정보")
        }
    }
    func hospitalView(hospital: Item)-> some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(hospital.dutyName ?? "조회 실패")
                .font(.bold18)
            Text(hospital.dutyAddr ?? "조회 실패")
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
