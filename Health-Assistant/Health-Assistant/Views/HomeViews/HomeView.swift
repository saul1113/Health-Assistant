//
//  HomeView.swift
//  Health-Assistant
//
//  Created by Hwang_Inyoung on 11/1/24.
//

import SwiftUI


extension Color {
    static var mainColor: Color {
        Color("MainColor")
    }
    static var mainColor30: Color {
        Color("MainColor").opacity(0.3)
    }
    static var mainColorD: Color {
        Color("MainColorDeep")
    }
}

struct HomeView: View {
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ZStack {
                    Color.mainColor
                        .ignoresSafeArea()
                        .overlay (alignment: .bottom){
                            RoundedRectangle(cornerRadius: 20)
                                .fill(.white)
                                .frame(height: geometry.size.height / 1.6)
                        }
                        .ignoresSafeArea()
                    VStack(spacing: 35) {
                        
                        healthDataView()
                        
                        sleepTime(geometry: geometry)
                        
                        chartView(geometry: geometry)
                        
                        Spacer()
                    }
                    .toolbar {
                        ToolbarItem(placement: .topBarLeading) {
                            Image(.hahaTitleWhite)
                        }
                        ToolbarItem(placement: .topBarTrailing) {
                            Image(systemName: "bell.fill")
                                .foregroundStyle(.white)
                        }
                    }
                }
            }
        }
    }
    func healthDataView() -> some View {
        VStack {
            Text("현재")
                .foregroundStyle(.white)
                .font(.regular20)
            Text("70")
                .foregroundStyle(.white)
                .font(.bold96)
                .padding(.vertical, -27)
            HStack {
                Text("BPM")
                    .foregroundStyle(.white)
                    .font(.regular20)
                Image(systemName: "heart.fill")
                    .foregroundStyle(.white)
            }
        }
    }
    func chartView(geometry: GeometryProxy) -> some View {
        HStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.mainColor.opacity(0.3))
                .frame(maxWidth: geometry.size.width / 2, maxHeight: geometry.size.height / 4)
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.mainColor.opacity(0.3))
                .frame(maxWidth: geometry.size.width / 2, maxHeight: geometry.size.height / 4)
        }
        .padding(.horizontal, 20)
    }
    
    func sleepTime(geometry: GeometryProxy) -> some View {
        VStack(spacing: 5) {
            let gaugeSize = geometry.size.width - 94
            let gaugePerOne = gaugeSize / 10
            Text("2024.11.03")
                .foregroundStyle(.gray)
                .font(.medium14)
                .frame(maxWidth: geometry.size.width, alignment: .leading)
            RoundedRectangle(cornerRadius: 18)
                .fill(Color.mainColorD)
                .frame(width: geometry.size.width - 94, height: 34)
                .overlay (alignment: .leading) {
                    RoundedRectangle(cornerRadius: 18)
                        .frame(width: gaugePerOne * 5 )
                        .foregroundStyle(.white)
                }
            HStack {
                Text("수면시간")
                    .foregroundStyle(.gray)
                    .font(.medium14)
                Text("6시간 33분")
                    .font(.bold16)
                    .foregroundStyle(.white)
                Spacer()
                Text("취침 시간")
                    .foregroundStyle(.gray)
                    .font(.medium14)
                Text("7시간 47분")
                    .font(.bold16)
            }
        }
        .padding(.horizontal, 47)
    }
}

#Preview {
    HomeView()
}
