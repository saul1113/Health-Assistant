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
    @Published private(set) var currentAddress: String?
    
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
    func fetchAddress( currentLocationString: @escaping (String, String) -> ()) {
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
                if let location = placemark.administrativeArea, let locality = placemark.locality {
                    currentLocationString(location, locality)
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
