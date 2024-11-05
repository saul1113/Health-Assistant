//
//  MedicationAddView.swift
//  Health-Assistant
//
//  Created by 김수민 on 11/4/24.
//

import SwiftUI

struct MedicationAddView: View {
    @ObservedObject var viewModel = MedicationViewModel()
    
    @State private var medicationName: String = ""
    @State private var selectedDays: [String] = []
    @State private var selectedTimes: [Date] = []
    @State private var medicationTime: String = ""
    @State private var medicationNote : String = ""
    @State private var timePicker: Bool = false
    @State private var time: Date = Date()
    
    @State private var iconViewSheet = false
    
    let week = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    ZStack {
                        Text("")
                            .padding(10)
                            .frame(width: 100, height: 100)
                            .background(Color.CustomGreen)
                            .clipShape(Circle())
                            .foregroundStyle(.white)
                            .font(.medium16)
                        VStack {
                            Image(systemName: "pill.fill")
                                .foregroundStyle(.white)
                                .font(.system(size: 40))
                            
                            Button(action: {
                                iconViewSheet.toggle()
                            }) {
                                Text("아이콘 추가")
                                    .foregroundColor(.white)
                                    .font(.semibold14)
                            }
                        }
                    }
                    .padding(.top, 10)
                    .padding(.bottom, 20)
                    VStack (alignment: .leading){
                        
                        TextField("약 이름", text: $medicationName)
                            .background(Color.clear)
                            .font(.semibold30)
                            .padding(.bottom, 40)
                        
                        HStack {
                            Text("요일")
                                .font(.semibold22)
                            
                            Spacer()
                            
                            Button(action: {
                                if selectedDays.count == week.count {
                                    selectedDays.removeAll()
                                } else {
                                    selectedDays = week
                                }
                            }) {
                                Text(selectedDays.count == week.count ? "선택 취소" : "모두 선택")
                                    .foregroundColor(.CustomGreen)
                                    .font(.regular16)
                            }
                        }
                        HStack(spacing: 10){
                            ForEach(week, id: \.self) { day in
                                Text(translateDayKorean(day))
                                    .padding(10)
                                    .frame(width: 40, height: 40)
                                    .background(selectedDays.contains(day) ? Color.CustomGreen : Color.gray.opacity(0.3))
                                    .clipShape(Circle())
                                    .foregroundColor(selectedDays.contains(day) ? .white : .black)
                                    .font(.semibold16)
                                    .onTapGesture {
                                        if selectedDays.contains(day) {
                                            selectedDays.removeAll { $0 == day }
                                        } else {
                                            selectedDays.append(day)
                                        }
                                    }
                            }
                        }
                        .padding(.bottom, 40)
                        
                        HStack {
                            Text("시간")
                                .font(.semibold22)
                            
                            Spacer()
                            
                            Button(action: {
                                timePicker.toggle()
                            }) {
                                Text("추가")
                                    .foregroundColor(.CustomGreen)
                                    .font(.regular16)
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.CustomGreen)
                            }
                        }
                        
                        if !selectedTimes.isEmpty {
                            ForEach(selectedTimes, id: \.self) { time in
                                displayTime(formatTimeToString(time))
                            }
                        }
                        
                        
                        if timePicker {
                            VStack {
                                DatePicker("시간 선택", selection: $time, displayedComponents: .hourAndMinute)
                                    .labelsHidden()
                                    .datePickerStyle(WheelDatePickerStyle())
                                    .frame(maxWidth: .infinity, maxHeight: 150)
                                    .padding()
                                
                                Button(action: {
                                    selectedTimes.append(time)
                                    timePicker = false
                                }) {
                                    Text("완료")
                                        .foregroundColor(.CustomGreen)
                                        .font(.semibold16)
                                }
                                .padding()
                            }
                        }
                        
                        HStack {
                            Text("메모")
                                .font(.semibold22)
                            
                            Text("선택사항")
                                .font(.regular12)
                                .padding(.top, 10)
                                .foregroundColor(.CustomGreen)
                        }
                        .padding(.bottom, 5)
                        .padding(.top, 30)
                        
                        TextEditor(text: $medicationNote)
                            .padding()
                            .scrollContentBackground(.hidden)
                            .background(Color.CustomGreen.opacity(0.1))
                            .cornerRadius(2)
                            .font(.regular14)
                            .frame(height: 150)
                        
                    }
                }
                .padding(30)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        print("취소 버튼 눌림")
                        dismiss()
                    }) {
                        Text("취소")
                            .foregroundStyle(.black)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        print("저장 버튼 눌림")
                        let formattedTimes = selectedTimes.map { formatTimeToString($0) }
                        viewModel.addMedication(name: medicationName, company: "", days: selectedDays, times: formattedTimes, note: medicationNote)
//
                        dismiss()
                    }) {
                        Text("저장")
                            .foregroundStyle(.black)
                    }
                }
            }
            .navigationTitle("약 추가")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $iconViewSheet) {
                MedicationIconView()
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
    MedicationAddView()
}
