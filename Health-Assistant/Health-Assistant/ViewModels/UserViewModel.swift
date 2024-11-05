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
    let url = "http://apis.data.go.kr/B552657/ErmctInfoInqireService/getEgytLcinfoInqire"
    //    let locationManager = LocationManager()
    
    func fetchHospitalLocation(local: String, locality: String) async {
            let url = "http://apis.data.go.kr/B552657/ErmctInfoInqireService/getEmrrmRltmUsefulSckbdInfoInqire"
            let serviceKey = "dVN/U3WDl0cxC8+FvHOLHWawaJ6KvrzGNa+QRPr6WV/kFjOSJi9JEmnpCtEkgsiIgDkfCwhk0Oxm4pOJOP87YA=="
            let pageNo = "1"
            let numOfRows = "10"
            let parameters: Parameters = [
                "STAGE1": local,
                "STAGE2": locality,
                "pageNo": pageNo,
                "numOfRows": numOfRows,
                "serviceKey": serviceKey
            ]
            AF.request(url, method: .get, parameters: parameters).response { response in
                switch response.result {
                case .success(let data):
                    if let data {
                        self.hospitalsInfo = try! XMLDecoder().decode(HostpitalResponse.self, from: data).body.items.item
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
}

