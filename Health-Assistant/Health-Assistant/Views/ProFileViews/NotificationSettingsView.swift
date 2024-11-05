//
//  NotificationsSettingsView.swift
//  Health-Assistant
//
//  Created by Hwang_Inyoung on 11/5/24.
//

import SwiftUI

struct NotificationSettingsView: View {
    @State private var notificationsEnabled: Bool = true
    
    var body: some View {
        Toggle(isOn: $notificationsEnabled) {
            Text("알림 수신 설정")
        }
        .padding()
        .navigationTitle("알림 설정")
    }
}
