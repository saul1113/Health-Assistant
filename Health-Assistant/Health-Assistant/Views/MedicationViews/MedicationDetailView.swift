//
//  MedicationDetailView.swift
//  Health-Assistant
//
//  Created by 김수민 on 11/4/24.
//

import SwiftUI

struct MedicationDetailView: View {
    var medication: Medication
    
    @State private var showDetailsSheet = false
    let gridItem: [GridItem] =  [GridItem(.flexible())]
    
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack (alignment: .leading, spacing: 40) {
                    HStack {
                        Text("약아이콘")
                            .frame(width: 80, height: 80)
                            .background(Color.CustomGreen)
                            .clipShape(Circle())
                            .foregroundStyle(.white)
                            .font(.medium16)
                            .padding(.trailing, 10)
                        
                        VStack(alignment: .leading, spacing: 10) {
                            Text(medication.name)
                                .font(.semibold24)
                            Text(medication.company)
                                .font(.regular14)
                        }
                        Spacer()
                    }
                    .padding(.top, 18)
                    
                    Text("요일")
                        .font(.semibold24)
                        .padding(.bottom, -20)
                    
                    LazyHGrid(rows: gridItem, spacing: 10) {
                        ForEach(medication.translatedDays(), id: \.self) { day in
                            Text(day)
                                .frame(width: 40, height: 40)
                                .background(Color.CustomGreen)
                                .clipShape(Circle())
                                .foregroundStyle(.white)
                                .font(.semibold16)
                        }
                    }
                    Text("시간")
                        .font(.semibold24)
                        .padding(.bottom, -20)
                    VStack {
                        ForEach(medication.times.indices, id: \.self) { index in
                            displayTime(medication.times[index])
                        }
                        .padding(.trailing, 10)
                    }
                    
                    Text("메모")
                        .font(.semibold24)
                        .padding(.bottom, -20)
                    
                    Text("\(medication.note)")
                        .font(.regular16)
                    
                    
                    Button(action: {
                        showDetailsSheet.toggle()
                    }) {
                        Text("내용 더보기")
                            .font(.semibold16)
                            .foregroundColor(Color(.customGreen))
                    }
                    .sheet(isPresented: $showDetailsSheet) {
                        DetailSheetView(medication: medication)
                    }
                    Spacer()
                }
                .padding(.horizontal, 20)
                .scrollIndicators(.never)
                .navigationTitle("\(medication.name) 정보")
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarBackButtonHidden(true)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        BackButton()
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            
                        }) {
                            Image(systemName: "pencil")
                                .foregroundStyle(.black)
                        }
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

struct DetailSheetView: View {
    var medication: Medication
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        
        NavigationStack {
            ScrollView {
                VStack (alignment: .leading, spacing: 40) {
                    Text(medication.name)
                        .font(.semibold26)
                        .padding(.horizontal, 5)
                        .background(Color.CustomGreen.opacity(0.3))
                        .cornerRadius(3)
                    
                    Text("효능")
                        .font(.semibold24)
                        .padding(.bottom, -20)
                    Text("약의 효능 내용")
                        .font(.regular14)
                    
                    Text("사용법")
                        .font(.semibold24)
                        .padding(.bottom, -20)
                    Text("사용법 내용")
                        .font(.regular14)
                    
                    Text("주의사항 / 경고")
                        .font(.semibold24)
                        .padding(.bottom, -20)
                    Text("주의사항 내용")
                        .font(.regular14)
                    
                    HStack {
                        Text("상호작용")
                            .font(.semibold24)
                         
                        Text("주의해야 할 약 또는 음식")
                            .font(.regular12)
                            .padding(.top, 15)
                            .foregroundColor(.CustomGreen)
                    }
                    .padding(.bottom, -20)
                    
                    Text("상호작용 내용")
                        .font(.regular14)
                    
                    HStack {
                        Text("부작용")
                            .font(.semibold24)
                         
                        Text("나타날 수도 있는 이상반응")
                            .font(.regular12)
                            .padding(.top, 15)
                            .foregroundColor(.CustomGreen)
                        
                        Spacer()
                    }
                    .padding(.bottom, -20)
                    
                    Text("부작용 내용")
                        .font(.regular14)
                    
                    Text("보관법")
                        .font(.semibold24)
                        .padding(.bottom, -20)
                    Text("보관법 내용")
                        .font(.regular14)
                    Spacer()
                }
                .padding(.horizontal, 25)
                .navigationBarBackButtonHidden(true)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            dismiss()
                        }) {
                            Image(systemName: "xmark")
                                .foregroundStyle(.black)
                        }
                    }
                }
            }
        }
        
    }
}

#Preview {
    MedicationDetailView(medication: Medication(name: "혈압약", company: "대웅제약", days:  ["Monday", "Wednesday", "Friday"], times: ["08:00 AM", "02:00 PM"], note: "식후 30분 후에 복용하기"))
}

