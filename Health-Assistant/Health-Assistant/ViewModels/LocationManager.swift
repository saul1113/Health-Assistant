//
//  LocationManager.swift
//  Health-Assistant
//
//  Created by Soom on 11/5/24.
//
import SwiftUI
import CoreLocation


class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private var geocoder: CLGeocoder
    private var locationManager = CLLocationManager()
    @Published private(set) var location: CLLocation?
    @Published private(set) var authorizationStatus: CLAuthorizationStatus?
    @Published private(set) var hospitalLocation: [CLLocationCoordinate2D] = []
    @Published private(set) var currentAddress: String?
    @Published private(set) var hospitalDistances: [Double] = []
    @Published private(set) var hospitalNames: [String] = []
    @Published private(set) var hospitalAddresses: [String] = []
    override init() {
        geocoder = CLGeocoder() // Geocoder 초기화
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        location = locationManager.location
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        authorizationStatus = status
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.first
    }
    @MainActor
    func fetchAddressFromLocation(hospitalAddress: [Item]) async {
        do {
            var distances: [Double] = []
            var hospitalNames: [String] = []
            var hospitalLocations: [CLLocationCoordinate2D] = []
            for hospitalAddrs in hospitalAddress {
                if let hospitalAddress = hospitalAddrs.dutyAddr{
                    let addressString = hospitalAddress.contains(",") ?
                    String(hospitalAddress.split(separator: ",")[0]) : hospitalAddress
                    let hospitalAddress = try? await geocoder.geocodeAddressString(addressString)
                    hospitalAddresses.append(addressString)
                    print(hospitalAddresses)
                    if let address = hospitalAddress?.first?.location {
                        self.hospitalLocation.append(address.coordinate)
                        //거리 계산 추가함
                        if let userLocation = location {
                            let distance = userLocation.distance(from: address) // 거리 계산 (미터 단위)
                            print("병원과의 거리: \(distance) 미터")
                            distances.append(distance)
                            let hospitalName = hospitalAddrs.dutyName
                            hospitalNames.append(hospitalName ?? "")
                            print(hospitalNames)
                        }
                    }
                }
            }
            self.hospitalDistances = distances
            self.hospitalNames = hospitalNames
            self.hospitalAddresses = hospitalAddresses
            
        } catch {
            print("Error geocoding address: \(error)")
        }
        
        
    }
    func fetchAddress( currentLocationString: @escaping (String) -> ()) {
        guard let coordinate = location?.coordinate else {
            return
        }
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        
        geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
            if let error = error {
                print("Geocoding failed: \(error.localizedDescription)")
                self?.currentAddress = "주소를 찾을 수 없습니다."
                return
            }
            
            if let placemark = placemarks?.first {
                if let location = placemark.administrativeArea {
                    currentLocationString(location)
                }
                self?.currentAddress = self?.formatPlacemark(placemark)
            } else {
                self?.currentAddress = "주소를 찾을 수 없습니다."
            }
        }
    }
    
    private func formatPlacemark(_ placemark: CLPlacemark) -> String {
        var addressString = ""
        
        if let locality = placemark.locality {
            addressString += locality
        }
        if let thoroughfare = placemark.thoroughfare {
            addressString += " \(thoroughfare)"
        }
        if let subThoroughfare = placemark.subThoroughfare {
            addressString += " \(subThoroughfare)"
        }
        
        return addressString
    }
}
