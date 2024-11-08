//
//  ContentView.swift
//  Health-Assistant
//
//  Created by Soom on 11/1/24.
//

import SwiftUI

struct MainTabView: View {
    @State private var selectedTab: Tab = .home
    enum Tab {
        case home
        case medison
        case healthList
        case profile
    }
    var body: some View {

        ZStack(alignment: .bottom){
            VStack(alignment: .center,spacing: 0) {
                switch selectedTab {
                case .home:
                    HomeView()
                        .tabItem() {
                            Label("Home", systemImage: "house")
                        }
                        .tag(0)
                case .medison:
                    MedicationMainView()
                        .tabItem() {
                            Label("medison", systemImage: "pill")
                        }
                        .tag(1)
                case .healthList:
                    HealthListView()
                        .tabItem() {
                            Label("HealthList", systemImage: "list.clipboard")
                        }
                        .tag(2)
                case .profile:
                    ProfileView()
                        .tabItem() {
                            Label("Profile", systemImage: "person.crop.circle")
                        }
                        .tag(3)
                }
            }
            TabBar(selectedTab: $selectedTab)
                .frame(alignment: .bottom)
                .background(.white)
        }
    }
}

struct TabBar: View {
    @Binding var selectedTab: MainTabView.Tab
    var body: some View {
        VStack(spacing: 0){
            Divider()
            HStack (spacing: 0){
                Button(action: {
                    selectedTab = .home
                }) {
                    VStack(alignment: .center,spacing: 0){
                        Image(systemName: "house")
                            .frame(width: 30,height: 30)
                            .foregroundColor(selectedTab == .home ? .customGreen : Color.customTabColor)
                        Text("홈")
                            .foregroundColor(selectedTab == .home ? .customGreen : .customTabColor)
                    }
                    .frame(height: 50)
                    .frame(maxWidth: .infinity)
                }
                Button{
                    selectedTab = .medison
                }label: {
                    VStack(alignment: .center,spacing: 0){
                        Image(systemName: "pill")
                            .frame(width: 30,height: 30)
                            .foregroundColor(selectedTab == .medison ? .customGreen : .customTabColor)
                        Text("약")
                            .foregroundColor(selectedTab == .medison ?  .customGreen : .customTabColor)
                    }
                    .frame(height: 50)
                    .frame(maxWidth: .infinity)
                }
                Button{
                    selectedTab = .healthList
                }label: {
                    VStack(alignment: .center,spacing: 0){
                        Image(systemName: "list.bullet.clipboard")
                            .frame(width: 30,height: 30)
                            .aspectRatio(contentMode: .fit)
                            .foregroundStyle(selectedTab == .healthList  ? .customGreen : .customTabColor)
                        Text("리포트")
                            .foregroundStyle(selectedTab == .healthList  ? .customGreen : .customTabColor)
                    }
                    .frame(height: 50)
                    .frame(maxWidth: .infinity)
                }
                Button{
                    selectedTab = .profile
                }label: {
                    VStack(alignment: .center,spacing: 0){
                        Image(systemName: "person.fill")
                            .frame(width: 30,height: 30)
                        Text("프로필")
                    }
                    .foregroundColor(selectedTab == .profile ? .customGreen : .customTabColor)
                    .frame(height: 50)
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .frame(height: 50)
        .frame(maxWidth: .infinity)
    }
}


#Preview {
    MainTabView()
}
