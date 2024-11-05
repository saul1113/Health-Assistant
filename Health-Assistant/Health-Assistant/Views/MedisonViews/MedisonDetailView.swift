//
//  MedisonDetailView.swift
//  Health-Assistant
//
//  Created by 김수민 on 11/4/24.
//

import SwiftUI

struct MedisonDetailView: View {
    var medison: Medison
    
    @State private var showDetailsSheet = false
    
    
    var body: some View {
        VStack (alignment: .leading) {
            HStack {
                Text("약 이미지")
                    .padding(10)
                    .frame(width: 90, height: 90)
                    .background(Color.CustomGreen)
                    .clipShape(Circle())
                    .foregroundStyle(.white)
                    .font(.medium16)
                    .padding(.trailing, 10)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text(medison.name)
                        .font(.semibold24)
                    Text("업체 이름")
                        .font(.regular14)
                }
            }
            .padding(.bottom, 40)
            
            Text("요일")
                .font(.semibold24)
            
            HStack(spacing: 20) {
                ForEach(medison.translatedDays(), id: \.self) { day in
                    Text(day)
                        .padding(10)
                        .frame(width: 40, height: 40)
                        .background(Color.CustomGreen)
                        .clipShape(Circle())
                        .foregroundStyle(.white)
                        .font(.semibold16)
                }
            }
            .padding(.bottom, 40)
            
            Text("시간")
                .font(.semibold24)
            VStack {
                ForEach(medison.times.indices, id: \.self) { index in
                    displayTime(medison.times[index])
                }
                .padding(.trailing, 10)
            }
            .padding(.bottom, 40)
            
            Text("메모")
                .font(.semibold24)
                .padding(.bottom, 5)
            
            Text("\(medison.note)")
                .font(.regular16)
                .padding(.bottom, 40)
            
            
            Button(action: {
                showDetailsSheet.toggle()
            }) {
                Text("내용 더보기")
                    .font(.semibold16)
                    .foregroundColor(Color(.customGreen))
                    .padding(.vertical, 10)
            }
            .sheet(isPresented: $showDetailsSheet) {
                DetailSheetView(medison: medison)
            }
            
            
            Spacer()
        }
        .padding(.trailing, 100)
        .padding(.top, 40)
        .navigationTitle("상세정보")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                BackButton()
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
                .font(.regular16)
                .foregroundColor(.black)
                .padding(.top, 7)
        }
    }
}

struct DetailSheetView: View {
    var medison: Medison
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                
                Text(medison.name)
                    .font(.semibold20)
                    .padding(.horizontal, 5)
                    .background(Color.CustomGreen.opacity(0.3))
                    .cornerRadius(3)
                    .padding(.bottom, 20)
                
                Text("효능")
                    .font(.semibold24)
                    .padding(.bottom, 5)
                Text("약의 효능 내용")
                    .font(.regular16)
                    .padding(.bottom, 40)
                
                Text("사용법")
                    .font(.semibold24)
                    .padding(.bottom, 5)
                Text("약의 사용법 내용")
                    .font(.regular16)
                    .padding(.bottom, 40)
                
                Text("주의사항 / 경고")
                    .font(.semibold24)
                    .padding(.bottom, 5)
                Text("주의사항 내용")
                    .font(.regular16)
                    .padding(.bottom, 40)
                
                Text("상호작용")
                    .font(.semibold24)
                    .padding(.bottom, 5)
                Text("상호작용 내용")
                    .font(.regular16)
                    .padding(.bottom, 40)
                
                Text("부작용")
                    .font(.semibold24)
                    .padding(.bottom, 5)
                Text("부작용 내용")
                    .font(.regular16)
                    .padding(.bottom, 40)
                
                Text("보관법")
                    .font(.semibold24)
                    .padding(.bottom, 5)
                Text("보관법 내용")
                    .font(.regular16)
                    .padding(.bottom, 40)
                
            }
            .padding(.trailing, 150)
            .padding(.top, 80)
        }
    }
}

#Preview {
    MedisonDetailView(medison: Medison(name: "약 이름 1", days:  ["Monday", "Wednesday", "Friday"], times: ["08:00 AM", "02:00 PM"], note: "공복에 복용하면 안됨"))
}
