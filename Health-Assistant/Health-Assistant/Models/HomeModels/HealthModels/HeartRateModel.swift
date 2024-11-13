//
//  HeartRateSample.swift
//  Health-Assistant
//
//  Created by Hwang_Inyoung on 11/10/24.
//

import Foundation

struct HeartRateModel: Identifiable {
    let id = UUID()
    let date: Date
    let value: Double
    
    static func ==(lhs: HeartRateModel, rhs: HeartRateModel) -> Bool {
        return lhs.id == rhs.id
    }
}
