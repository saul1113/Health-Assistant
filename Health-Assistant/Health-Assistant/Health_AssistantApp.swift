//
//  Health_AssistantApp.swift
//  Health-Assistant
//
//  Created by Soom on 11/1/24.
//

import SwiftUI

@main
struct Health_AssistantApp: App {
    @StateObject private var medicationViewModel: MedicationViewModel = MedicationViewModel()
    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environmentObject(medicationViewModel)
        }
    }
}
