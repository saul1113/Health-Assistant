//
//  MedisonViewModel.swift
//  Health-Assistant
//
//  Created by 김수민 on 11/4/24.
//

import SwiftUI
import Combine

class MedisonViewModel: ObservableObject {
    @Published var medisons: [Medison] = []
    @Published var todayMedisons: [Medison] = []
    
    init() {
        medisons = Medison.dummyList
        filterTodayMedisons()
    }
    
    // 오늘 복용해야 할 약 필터링
    func filterTodayMedisons() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        
        let today = dateFormatter.string(from: Date()).lowercased()  // 소문자로 변환
        todayMedisons = medisons.filter { $0.days.contains(where: { $0.lowercased() == today }) }
    }
    
    // 복용 상태 업데이트
    func toggleTakeMedison(for medison: Medison, at index: Int) {
        if let medisonIndex = todayMedisons.firstIndex(where: { $0.id == medison.id }) {
            todayMedisons[medisonIndex].isTaken[index].toggle()
        }
    }
}
