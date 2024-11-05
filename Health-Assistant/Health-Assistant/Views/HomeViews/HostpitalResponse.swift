//
//  HostpitalResponse.swift
//  Health-Assistant
//
//  Created by Soom on 11/5/24.
//
import Foundation

struct HostpitalResponse: Codable {
    struct Header: Codable {
        let resultCode: String
        let resultMsg: String
    }
    struct Body: Codable {
        let items: Items
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
struct Items: Codable {
    let item: [Item]
}

struct Item: Codable {
    let dutyName: String
    let dutyTel3: String
    let hpid: String
    let hv30: String?
    let hv5: String?
    let hv7: String?
    let hvamyn: String?
    let hvangioayn: String?
    let hvcrrtayn: String?
    let hvctayn: String?
    let hvec: String?
    let hvecmoayn: String?
    let hvgc: String?
    let hvhypoayn: String?
    let hvidate: String?
    let hvincuayn: String?
    let hvmriayn: String?
    let hvoc: String?
    let hvoxyayn: String?
    let hvs01: String?
    let hvs03: String?
    let hvs04: String?
    let hvs17: String?
    let hvs22: String?
    let hvs26: String?
    let hvs27: String?
    let hvs28: String?
    let hvs29: String?
    let hvs30: String?
    let hvs38: String?
    let hvventiayn: String?
    let hvventisoayn: String?
    let phpid: String?
    let rnum: String?
}
