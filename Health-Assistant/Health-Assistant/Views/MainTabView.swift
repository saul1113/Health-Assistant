//
//  ContentView.swift
//  Health-Assistant
//
//  Created by Soom on 11/1/24.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem() {
                    Label("홈", systemImage: "house")
                }
                .tag(0)
            
            MedicationMainView()
                .tabItem() {
                    Label("약 복용", systemImage: "pill")
                }
                .tag(1)
            
            HealthListView()
                .tabItem() {
                    Label("건강 기록", systemImage: "list.clipboard")
                }
                .tag(2)
            
            ProfileView()
                .tabItem() {
                    Label("프로필", systemImage: "person.crop.circle")
                }
                .tag(3)
        }
        .accentColor(Color("CustomGreen"))
    }
}


#Preview {
    MainTabView()
}
