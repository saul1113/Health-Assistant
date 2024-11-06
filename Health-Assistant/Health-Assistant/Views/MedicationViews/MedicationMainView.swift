//
//  MedicationMainView.swift
//  Health-Assistant
//
//  Created by 김수민 on 11/4/24.
//

import SwiftUI

struct MedicationMainView: View {
    
    @EnvironmentObject var viewModel: MedicationViewModel
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack (alignment: .leading) {
                    Text("알약 아이콘을 눌러 복용 상태를 체크하세요")
                        .padding(.leading, 15)
                        .padding(.bottom, -5)
                        .font(.medium16)
                        .foregroundStyle(.gray)
                    
                    ForEach(viewModel.todayMedications) { medication in
                        VStack(alignment: .leading) {
                            HStack {
                                Text(medication.name)
                                    .font(.semibold20)
                                    .padding(.horizontal, 5)
                                    .background(Color.CustomGreen.opacity(0.3))
                                    .cornerRadius(3)
                                
                                Spacer()
                                
                                NavigationLink(destination: MedicationDetailView(medication: medication)) {
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.black)
                                        .font(.system(size: 25))
                                        .padding(.trailing, 10)
                                }
                            }
                            .padding()
                            .padding(.bottom, -10)
                            
                            ForEach(medication.times.indices, id: \.self) { index in
                                HStack {
                                    displayTime(medication.times[index])
                                    Spacer()
                                    Button(action: {
                                        viewModel.toggleTakeMedication(for: medication, at: index)
                                    }) {
                                        VStack(spacing: 5){
                                            Image(systemName: medication.isTaken[index] ? "pill.fill" : "pill")
                                                .foregroundColor(medication.isTaken[index] ? .CustomGreen : .gray)
                                                .font(.system(size: 30))
                                            
                                            Text(medication.isTaken[index] ? "복용 완료 !" : "복용 전")
                                                .frame(width: 70)
                                                .multilineTextAlignment(.center)
                                                .fixedSize()
                                                .font(.medium14)
                                                .foregroundColor(medication.isTaken[index] ? .CustomGreen : .black)
                                        }
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                        .padding(.vertical)
                        
                        Divider()
                    }
                }
                .padding(25)
                
                Image("medicationOn")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 50, height: 50)
            }
            .onAppear {
                viewModel.filterTodayMedications()
            }
            .navigationTitle("오늘 복용 약")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: MedicationSearchView()) {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.black)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: MedicationListView()) {
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
                .font(.medium28)
                .foregroundColor(.black)
            
            Text(second)
                .font(.regular16)
                .foregroundColor(.black)
                .padding(.top, 7)
        }
    }
}


#Preview {
    MedicationMainView()
        .environmentObject(MedicationViewModel())
}
