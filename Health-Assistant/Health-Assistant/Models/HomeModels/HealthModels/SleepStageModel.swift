//
//  SleepStageModel.swift
//  Health-Assistant
//
//  Created by Hwang_Inyoung on 11/11/24.
//

import SwiftUI

struct SleepStageModel: Identifiable {
    let id = UUID()
    var startDate: Date
    var endDate: Date
    let stage: SleepStage
}

enum SleepStage: String {
    case awake = "비수면"
    case rem = "REM 수면"
    case core = "코어 수면"
    case deep = "깊은 수면"
    
    var color: Color {
        switch self {
        case .awake: return .orange
        case .rem: return .blue.opacity(0.5)
        case .core: return .blue
        case .deep: return .indigo
        }
    }
}
