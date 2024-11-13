//
//  UserViewModel.swift
//  Health-Assistant
//
//  Created by Soom on 11/5/24.
//

import SwiftUI
import Alamofire
import XMLCoder



class UserViewModel: ObservableObject {
    @Published private(set) var hospitalsInfo: [Item] = []
    let locationManager = LocationManager()
    let url = "http://apis.data.go.kr/B552657/ErmctInfoInqireService/getEgytLcinfoInqire"
    //    let locationManager = LocationManager()
    
    func fetchHospitalLocation(local: String, completion: @escaping ([Item]) -> () ) async {
        let url = "http://apis.data.go.kr/B552657/ErmctInfoInqireService/getEgytListInfoInqire"
        let serviceKey = "dVN/U3WDl0cxC8+FvHOLHWawaJ6KvrzGNa+QRPr6WV/kFjOSJi9JEmnpCtEkgsiIgDkfCwhk0Oxm4pOJOP87YA=="
        let pageNo = "1"
        let numOfRows = "10"
        let parameters: Parameters = [
            "Q0": local,
            "pageNo": pageNo,
            "numOfRows": numOfRows,
            "serviceKey": serviceKey
        ]
        let decoder = XMLDecoder()
        decoder.keyDecodingStrategy = .convertFromCapitalized
        AF.request(url, method: .get, parameters: parameters).response { [self] response in
            switch response.result {
            case .success(let data):
                if let data {
                    do {
                        self.hospitalsInfo = try decoder.decode(HostpitalResponse.self, from: data).body.items.item
                        completion(hospitalsInfo)
                    } catch {
                        print("Hospital Response: \(error.localizedDescription)")
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

