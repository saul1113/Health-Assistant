//
//  Health_AssistantApp.swift
//  Health-Assistant
//
//  Created by Soom on 11/1/24.
//

import SwiftUI
import SwiftData

@main
struct Health_AssistantApp: App {
    var body: some Scene {
        WindowGroup {
            MainTabView()
                .modelContainer(for: [CalendarEvent.self, Medication.self])
        }
    }
}
