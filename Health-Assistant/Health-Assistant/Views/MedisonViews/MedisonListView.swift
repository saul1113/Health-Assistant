//
//  MedisonListView.swift
//  Health-Assistant
//
//  Created by 김수민 on 11/5/24.
//

import SwiftUI

struct MedisonListView: View {
    
    @ObservedObject var viewModel = MedisonViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment:.leading){
                    ForEach(viewModel.medisons) { medison in
                        HStack {
                            Text("약 이미지")
                                .padding(10)
                                .frame(width: 90, height: 90)
                                .background(Color.CustomGreen)
                                .clipShape(Circle())
                                .foregroundStyle(.white)
                                .font(.medium16)
                                .padding(.trailing, 10)
                            
                            VStack(alignment: .leading, spacing: 5) {
                                Text(medison.name)
                                    .font(.semibold20)
                                Text("업체 이름")
                                    .font(.regular14)
                                Text("2024.08.16부터 복용 중")
                                    .font(.regular10)
                                    .foregroundStyle(.gray)
                            }
                            
                            Spacer()
                            
                            NavigationLink(destination: MedisonDetailView(medison: medison)) {
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.black)
                            }
                        }
                        .padding(.bottom, 40)
                    }
                }
                .padding(40)
            }
                
            }
            .onAppear {
                viewModel.filterTodayMedisons()
            }
            .navigationTitle("내가 복용하는 약")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    BackButton()
                }
            }
        }
    }

#Preview {
    MedisonListView()
}
