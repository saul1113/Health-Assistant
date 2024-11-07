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
                    ForEach(viewModel.todayMedications) { medication in
                        VStack(alignment: .leading) {
                            HStack {
                                Text(medication.name)
                                    .font(.semibold18)
                                    .foregroundColor(Color(.customGreen))
                                    .cornerRadius(3)
                                
                                
                                Spacer()
                                
                                NavigationLink(destination: MedicationDetailView(medication: medication)) {
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(Color(.customGreen))
                                }
                            }
                            .padding(.bottom, -5)
                            
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
                                                .padding(10)
                                                .background(medication.isTaken[index] ? Color.CustomGreen.opacity(0.1) : Color.gray.opacity(0.1))
                                                .cornerRadius(30)
                                            
                                            Text(medication.isTaken[index] ? "복용 완료 !" : "복용 전")
                                                .frame(width: 70)
                                                .multilineTextAlignment(.center)
                                                .fixedSize()
                                                .font(.medium14)
                                                .foregroundColor(medication.isTaken[index] ? .CustomGreen : .black)
                                        }
                                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                                    }
                                }
                            }
                        }
                        .padding(.vertical)
                        
                        Divider()
                    }
                }
                .padding(.horizontal,20)
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
                .font(.regular18)
                .foregroundColor(.black)
                .padding(.top, 7)
        }
    }
}


#Preview {
    MedicationMainView()
        .environmentObject(MedicationViewModel())
}
