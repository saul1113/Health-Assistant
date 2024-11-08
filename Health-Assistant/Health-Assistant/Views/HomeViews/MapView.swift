//
//  MapView.swift
//  Health-Assistant
//
//  Created by Soom on 11/7/24.
//

import SwiftUI
import MapKit

struct MapView: View {
    @StateObject private var locationManager = LocationManager()
    let locationName: String
    let location: String
    var body: some View {
        Map {
            if let myLocaion = locationManager.hospitalLocation {
                Annotation("",coordinate: myLocaion) {
                    ZStack {
                        ZStack {
                            RoundedRectangle(cornerRadius: 5)
                                .fill(Color.customGreen02)
                            Text("🏥 \(locationName)")
                                .padding(5)
                        }
                    }
                }
            }
        }
        .task {
            await locationManager.fetchAddressFromLocation(hospitalAddress: location)
        }
    }
}
#Preview {
    MapView(locationName: "", location: "")
}
