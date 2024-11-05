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
            //테스트위해 넣어놨어용 머지시에 지우기
            HealthListView()
        }
    }
}

#Preview {
    MainTabView()
}
