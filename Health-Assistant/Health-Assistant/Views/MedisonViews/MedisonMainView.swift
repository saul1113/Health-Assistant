//
//  MedisonMainView.swift
//  Health-Assistant
//
//  Created by 김수민 on 11/4/24.
//

import SwiftUI

struct MedisonMainView: View {
    @ObservedObject var viewModel = MedisonViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    // 오늘 복용해야 할 약 리스트 출력
                    ForEach(viewModel.todayMedisons) { medison in
                        VStack(alignment: .leading) {
                            HStack {
                                Text(medison.name)
                                    .font(.semibold20)
                                    .padding(.horizontal, 5)
                                    .background(Color.CustomGreen.opacity(0.3))
                                    .cornerRadius(3)
                                
                                Spacer()
                                
                                NavigationLink(destination: MedisonDetailView(medison: medison)) {
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.black)
                                }
                            }
                            .padding()
                            
                            // 복용 시간 목록
                            ForEach(medison.times.indices, id: \.self) { index in
                                HStack {
                                    displayTime(medison.times[index])
                                    Spacer()
                                    Button(action: {
                                        viewModel.toggleTakeMedison(for: medison, at: index)
                                    }) {
                                        Image(medison.isTaken[index] ? "off" : "on")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 50, height: 50)
                                        
                                    }
                                }
                                .padding(.horizontal)
                            }
                            .padding(.vertical)
                        }
                        .padding(.vertical)
                        
                        Divider()
                    }
                }
                .padding()
                
                Image("medisonOn")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 50, height: 50)
            }
            .onAppear {
                viewModel.filterTodayMedisons()
            }
            .navigationTitle("오늘 먹을 약")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: MedisonAddView()) {
                        Image(systemName: "plus")
                            .foregroundColor(.black)
                    }                }
                ToolbarItem(placement: .navigationBarTrailing) {
                                NavigationLink(destination: MedisonListView()) {
                        Image(systemName: "line.horizontal.3")
                            .foregroundColor(.black)
                    }
                }
            }
        }
    }
    
    private func displayTime(_ time: String) -> some View {
        let components = time.split(separator: " ")
        let first = components[0]
        let second = components[1]
        
        let formatFirst = first.replacingOccurrences(of: ":", with: " : ")
        
        return HStack(spacing: 10) {
            Text(formatFirst)
                .font(.medium24)
                .foregroundColor(.black)
            
            Text(second)
                .font(.regular14)
                .foregroundColor(.black)
                .padding(.top, 7)
        }
    }
}


#Preview {
    MedisonMainView()
}
