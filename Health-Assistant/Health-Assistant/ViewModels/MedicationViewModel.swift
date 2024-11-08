//
//  MedicationViewModel.swift
//  Health-Assistant
//
//  Created by 김수민 on 11/4/24.
//

import SwiftUI
import Combine
import Alamofire
import XMLCoder

class MedicationViewModel: ObservableObject {
    @Published var medications: [Medication] = []
    @Published var todayMedications: [Medication] = []
    @Published private(set) var medicationsInfo: [Medication] = []
    
    init() {
        medications = Medication.dummyList
        filterTodayMedications()
    }
    
    // 오늘 복용해야 할 약 필터링
    func filterTodayMedications() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        
        let today = dateFormatter.string(from: Date()).lowercased()  // 소문자로 변환
        todayMedications = medications.filter { $0.days.contains(where: { $0.lowercased() == today }) }
    }
    
    // 복용 상태 업데이트
    func toggleTakeMedication(for medication: Medication, at index: Int) {
        if let medicationIndex = todayMedications.firstIndex(where: { $0.id == medication.id }) {
            todayMedications[medicationIndex].isTaken[index].toggle()
        }
    }
    
    // 복용 약 추가
    func addMedication(name: String, company: String, days: [String], times: [String], note: String) {
        let newMedication = Medication(name: name, company: company,days: days, times: times, note: note)
        medications.append(newMedication)
        print("new:\(newMedication)")
    }
    
    
    
    func fetchMedications(local: String, locality: String) async {
        let url = "http://apis.data.go.kr/1471000/DrbEasyDrugInfoService"
        let serviceKey = "jWOjrutwzF9Lrt7K8SUJoUn2F+1Vj3nfQJgknlMuq6hgcZsP9P9VY/2Wk9jauomuaQzDgeczvrSmOMNxWKQorQ=="
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
//                    self.medicationsInfo = try! XMLDecoder().decode(MedicationResponse.self, from: data).body.infos.info
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
}
