//
//  UserViewModel.swift
//  Health-Assistant
//
//  Created by Soom on 11/5/24.
//

import SwiftUI
import Alamofire

struct Items: Codable {
    init() {}
}

struct HospitalLocation: Decodable {
    let resultCode: String
    let resultMsg: String
    let items: Items
    let numOfRows: Int
    let pageNo: Int
    let totalCount: Int
    
    enum CodingKeys: String, CodingKey {
        case header
        case body
    }
    
    enum HeaderKeys: String, CodingKey {
        case resultCode, resultMsg
    }
    
    enum BodyKeys: String, CodingKey {
        case items, numOfRows, pageNo, totalCount
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let headerContainer = try container.nestedContainer(keyedBy: HeaderKeys.self, forKey: .header)
        resultCode = try headerContainer.decode(String.self, forKey: .resultCode)
        resultMsg = try headerContainer.decode(String.self, forKey: .resultMsg)
        
        let bodyContainer = try container.nestedContainer(keyedBy: BodyKeys.self, forKey: .body)
        items = try bodyContainer.decode(Items.self, forKey: .items)
        numOfRows = try bodyContainer.decode(Int.self, forKey: .numOfRows)
        pageNo = try bodyContainer.decode(Int.self, forKey: .pageNo)
        totalCount = try bodyContainer.decode(Int.self, forKey: .totalCount)
    }
}


class UserViewModel: ObservableObject {
    let url = "http://apis.data.go.kr/B552657/ErmctInfoInqireService/getEgytLcinfoInqire"
    let locationManager = LocationManager()
    
    func fetchHospitalLocation() async throws {
        let url = "http://apis.data.go.kr/B552657/ErmctInfoInqireService/getEgytLcinfoInqire"
        let serviceKey = "dVN/U3WDl0cxC8+FvHOLHWawaJ6KvrzGNa+QRPr6WV/kFjOSJi9JEmnpCtEkgsiIgDkfCwhk0Oxm4pOJOP87YA=="
        let pageNo = "1"
        let numOfRows = "10"
        guard let location = locationManager.location else {
            print("location is nil;")
            return }
        let lon = location.coordinate.longitude
        let lat = location.coordinate.latitude
        print("lon: \(lon.description)")
        print("lat: \(lat.description)")
        
        let parameters: Parameters = [
            "WGS84_LON": lon.description,
            "WGS84_LAT": lat.description,
            "pageNo": pageNo,
            "numOfRows": numOfRows,
            "serviceKey": serviceKey
        ]
        AF.request(url, method: .get, parameters: parameters).responseDecodable(of: HospitalLocation.self) { response in
            switch response.result {
            case .success(let data):
                print(data.items)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

