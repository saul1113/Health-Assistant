//
//  MedicationFinder.swift
//  Health-Assistant
//
//  Created by 김수민 on 11/13/24.
//

import Foundation
import Alamofire

class MedicationFinder: ObservableObject {
    @Published var medications: [Medication] = []

    let endPoint = "http://apis.data.go.kr/1471000/DrbEasyDrugInfoService"
}
