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
                    Label("Home", systemImage: "house")
                }
                .tag(0)
            
            MedisonMainView()
                .tabItem() {
                    Label("medison", systemImage: "pill")
                }
                .tag(1)
            
            HealthListView()
                .tabItem() {
                    Label("HealthList", systemImage: "list.clipboard")
                }
                .tag(2)
            
            ProfileView()
                .tabItem() {
                    Label("Profile", systemImage: "person.crop.circle")
                }
                .tag(3)
            
        }
        .accentColor(Color("CustomGreen"))
    }
}

#Preview {
    MainTabView()
}
