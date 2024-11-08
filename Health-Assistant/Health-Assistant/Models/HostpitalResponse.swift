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
    let dutyAddr: String?
    let dutyName: String?
    let emcOrgCod: String?
    let hpid: String?
    let rnum: Int?
    let symBlkEndDtm: String?
    let symBlkMsg: String?
    let symBlkMsgTyp: String?
    let symBlkSttDtm: String?
    let symOutDspMth: String?
    let symOutDspYon: String?
    let symTypCod: String?
    let symTypCodMag: String?
}
