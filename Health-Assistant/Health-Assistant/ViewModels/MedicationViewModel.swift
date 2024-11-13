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
import SwiftData

class MedicationViewModel: ObservableObject {
    @Published var medications: [Medication] = []
    
    @Published var todayMedications: [Medication] = []
    @Published private(set) var medicationsInfo: [Medication] = []
    
    private let dataSource: MedicationDataSource
    
    init(dataSource: MedicationDataSource) {
        self.dataSource = dataSource
        medications = dataSource.fetchMedications()
    }
    
    // 복용 약 로드
    func fetchMedications() {
        medications = dataSource.fetchMedications()
    }
    
    // 오늘 복용 약 로드
    func fetchTodayMedication() {
        fetchMedications()
        filterTodayMedications()
    }
    
    // 복용 약 추가
    func addMedication(medication: Medication) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.dataSource.addMedication(medication)
        }
    }
    
    //복용 약 삭제
    func deleteMedication(medication: Medication) {
        dataSource.deldeteMedication(medication)
        fetchMedications()
    }
    
    //복용 약 업데이트
    func updateMedication(medication: Medication) {
        dataSource.updateMedication(medication)
        fetchMedications()
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
    
    func timesToDates(_ times: [String]) -> [Date] {
        var dates: [Date] = []
        for timeString in times {
            let formatter = DateFormatter()
            formatter.dateFormat = "hh:mm a"
            
            if let time = formatter.date(from: timeString) {
                dates.append(time)
            } else {
                print("Failed to convert time: \(timeString)")
            }
        }
        
        return dates
    }
    
    func checkMinuteMedications(_ medication: Medication) -> [Bool] {
        let currentDate = Date()
        let thirtyMinutesInSeconds: TimeInterval = 30 * 60
        var isTimePassedArray: [Bool] = []

        for (index, timeString) in medication.times.enumerated() {
            if let medicationTime = timeToDate(timeString, currentDate: currentDate) {
                let timeDifference = currentDate.timeIntervalSince(medicationTime)
                let isPassed = (timeDifference > thirtyMinutesInSeconds && !medication.isTaken[index])
                isTimePassedArray.append(isPassed)
            } else {
                isTimePassedArray.append(false)
            }
        }

        return isTimePassedArray
    }
    
    func timeToDate(_ timeString: String, currentDate: Date) -> Date? {
        let formatter = DateFormatter()
            formatter.dateFormat = "hh:mm a"

            let calendar = Calendar.current
            let components = calendar.dateComponents([.year, .month, .day], from: currentDate)

            if let time = formatter.date(from: timeString) {

                return calendar.date(bySettingHour: calendar.component(.hour, from: time),
                                     minute: calendar.component(.minute, from: time),
                                     second: 0,
                                     of: calendar.date(from: components)!)
            }
            
            print("Invalid time format: \(timeString)")
            return nil
    }

    
    //    func fetchMedications(local: String, locality: String) async {
    //        let url = "http://apis.data.go.kr/1471000/DrbEasyDrugInfoService"
    //        let serviceKey = "jWOjrutwzF9Lrt7K8SUJoUn2F+1Vj3nfQJgknlMuq6hgcZsP9P9VY/2Wk9jauomuaQzDgeczvrSmOMNxWKQorQ=="
    //        let pageNo = "1"
    //        let numOfRows = "10"
    //        let parameters: Parameters = [
    //            "STAGE1": local,
    //            "STAGE2": locality,
    //            "pageNo": pageNo,
    //            "numOfRows": numOfRows,
    //            "serviceKey": serviceKey
    //        ]
    //        AF.request(url, method: .get, parameters: parameters).response
    //        { response in
    //            switch response.result {
    //            case .success(let data):
    //                if let data {
    ////                    self.medicationsInfo = try! XMLDecoder().decode(MedicationResponse.self, from: data).body.infos.info
    //                }
    //            case .failure(let error):
    //                print(error.localizedDescription)
    //            }
    //        }
    //    }
    
}
extension Medication {
    static let dummyList: [Medication] = [Medication(name: "혈압약", company: "대웅제약", days:  ["thursday", "Friday"], times: ["08:00 AM", "02:00 PM"], note: "식후 30분 후에 복용하기"),
                                          Medication(name: "진통제", company: "동국제약",days:  ["Wednesday", "thursday", "Friday"], times: ["08:00 AM", "02:00 PM", "10:00 PM"], note: "부작용 있을 수 있음"),
                                          Medication(name: "영양제", company: "뉴젠팜",days:  ["thursday"], times: ["08:00 AM", "02:00 PM", "10:00 PM"], note: "물과 함게 복용하기. 음료수 안됨"),
                                          Medication(name: "타이레놀",company: "BMS 제약",days:  ["TuesDay", "Wednesday", "thursday","Friday"], times: ["08:00 AM", "02:00 PM", "10:00 PM"], note: "공복에 섭취하지 않기"),
    ]
}
