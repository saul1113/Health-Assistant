//
//  SleepStageModel.swift
//  Health-Assistant
//
//  Created by Hwang_Inyoung on 11/11/24.
//

import SwiftUI

struct SleepStageModel: Identifiable {
    let id = UUID()
    let startDate: Date
    let endDate: Date
    let stage: SleepStage
}

enum SleepStage {
    case awake, rem, core, deep
    
    var description: String {
        switch self {
        case .awake: return "비수면"
        case .rem: return "REM 수면"
        case .core: return "코어 수면"
        case .deep: return "깊은 수면"
        }
    }
    
    var color: Color {
        switch self {
        case .awake: return .gray
        case .rem: return .purple
        case .core: return .blue
        case .deep: return .indigo
        }
    }
}
