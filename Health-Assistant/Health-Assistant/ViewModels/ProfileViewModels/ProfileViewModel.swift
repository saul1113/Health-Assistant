//
//  ProfileViewModel.swift
//  Health-Assistant
//
//  Created by Hwang_Inyoung on 11/5/24.
//

import Foundation
import SwiftUI

class ProfileViewModel: ObservableObject {
    @Published var profile = Profile(nickname: "앱스쿨", birthDate: "2024.11.05", bloodType: "AB형")
    
    func updateNickname(_ nickname: String) {
        profile.nickname = nickname
    }
    
    func updateBirthDate(_ birthDate: String) {
        profile.birthDate = birthDate
    }
    
    func updateBloodType(_ bloodType: String) {
        profile.bloodType = bloodType
    }
}
