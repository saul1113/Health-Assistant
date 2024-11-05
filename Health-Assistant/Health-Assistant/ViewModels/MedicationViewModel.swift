//
//  MedicationViewModel.swift
//  Health-Assistant
//
//  Created by 김수민 on 11/4/24.
//

import SwiftUI
import Combine

class MedicationViewModel: ObservableObject {
    @Published var medications: [Medication] = []
    @Published var todayMedications: [Medication] = []
    
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
}
