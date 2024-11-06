//
//  MedicationListView.swift
//  Health-Assistant
//
//  Created by 김수민 on 11/5/24.
//

import SwiftUI

struct MedicationListView: View {
    
    @EnvironmentObject var viewModel: MedicationViewModel
    
    @State private var addViewSheet = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment:.leading){
                    ForEach(viewModel.medications) { medication in
                        HStack {
                            Text("약아이콘")
                                .padding(10)
                                .frame(width: 80, height: 80)
                                .background(Color.CustomGreen)
                                .clipShape(Circle())
                                .foregroundStyle(.white)
                                .font(.medium16)
                                .padding(.trailing, 10)
                            
                            VStack(alignment: .leading, spacing: 5) {
                                Text(medication.name)
                                    .font(.semibold20)
                                Text(medication.company)
                                    .font(.regular14)
                                Text("2024.08.16부터 복용 중")
                                    .font(.regular10)
                                    .foregroundStyle(.gray)
                            }
                            
                            Spacer()
                            
                            NavigationLink(destination: MedicationDetailView(medication: medication)) {
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.black)
                            }
                        }
                        .padding(.bottom, 40)
                    }
                }
                .padding(35)
            }
            
        }
        .onAppear {
            viewModel.filterTodayMedications()
        }
        .navigationTitle("내가 복용하는 약")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                BackButton()
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    addViewSheet.toggle()
                }) {
                    Image(systemName: "plus")
                        .foregroundColor(.black)
                }
                
            }
        }
        .sheet(isPresented: $addViewSheet) {
            MedicationAddView()
                .environmentObject(viewModel)
        }
    }
}

#Preview {
    MedicationListView()
        .environmentObject(MedicationViewModel())
    
}
