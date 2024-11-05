//
//  MedicationMainView.swift
//  Health-Assistant
//
//  Created by 김수민 on 11/4/24.
//

import SwiftUI

struct MedicationMainView: View {
    @ObservedObject var viewModel = MedicationViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
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
                                }
                            }
                            .padding()
                            
                            ForEach(medication.times.indices, id: \.self) { index in
                                HStack {
                                    displayTime(medication.times[index])
                                    Spacer()
                                    Button(action: {
                                        viewModel.toggleTakeMedication(for: medication, at: index)
                                    }) {
                                        //                                        Image(medication.isTaken[index] ? "off" : "on")
                                        //                                            .resizable()
                                        //                                            .scaledToFit()
                                        //                                            .frame(width: 50, height: 50)
                                        
                                        Image(systemName: medication.isTaken[index] ? "pill.fill" : "pill")
                                            .foregroundColor(medication.isTaken[index] ? .CustomGreen : .gray)
                                            .font(.system(size: 30))
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
    MedicationMainView()
}
