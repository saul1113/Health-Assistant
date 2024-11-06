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
            VStack {
                List (hospitals, id: \.dutyName) { hospital in
                    NavigationLink {
                    } label: {
                        VStack {
                            Text(hospital.dutyName)
                            Text(hospital.dutyTel3)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    HospitalMapView(hospitals: [])
}
