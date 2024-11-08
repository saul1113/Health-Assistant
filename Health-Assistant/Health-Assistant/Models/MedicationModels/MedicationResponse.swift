//
//  MedicationResponse.swift
//  Health-Assistant
//
//  Created by 김수민 on 11/7/24.
//

import Foundation

struct MedicationResponse: Codable {
    struct Header: Codable {
        let resultCode: String
        let resultMsg: String
    }
    struct Body: Codable {
        let infos: Infos
        let numOfRows: Int
        let pageNo: Int
        let totalCount: Int
    }
    
    let header: Header
    let body: Body
    
    enum CodingKeys: String, CodingKey {
        case header
        case body
        
    }
}

struct Infos: Codable {
    let info: [Info]
}

struct Info: Codable {
}
