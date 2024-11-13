import SwiftUI

struct MedicationMainView: View {
    @StateObject var viewModel: MedicationViewModel = MedicationViewModel(dataSource: .shared)
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack (alignment: .leading) {
                    HStack {
                        Text("\(getTodayDateAndDayOfWeek().month)월")
                        
                        Text("\(getTodayDateAndDayOfWeek().day)일")
                        Text("\(translateDayKorean(getTodayDateAndDayOfWeek().dayOfWeek))요일")
                    }
                    .font(.medium26)
                    .padding(.top, 20)
                    
                    Divider()
                    
                    
                    ForEach(viewModel.todayMedications) { medication in
                        VStack(alignment: .leading) {
                            HStack {
                                VStack(alignment: .leading) {
                                    NavigationLink(destination: MedicationDetailView(medication: medication).environmentObject(viewModel)) {
                                        HStack {
                                            Text(medication.name)
                                                .font(.semibold18)
                                                .foregroundColor(Color(.customGreen))
                                            Image(systemName: "chevron.right")
                                                .foregroundColor(Color(.customGreen))
                                        }
                                    }
                                    
                                    ForEach(medication.times.indices, id: \.self) { index in
                                        HStack {
                                            TimeView(time: medication.times[index])
                                            Spacer()
                                            Button(action: {
                                                viewModel.toggleTakeMedication(for: medication, at: index)
                                            }) {
                                                HStack(spacing: 5) {
                                                    Image(systemName: medication.isTaken[0] ? "pill.fill" : "pill")
                                                        .foregroundColor(medication.isTaken[0] ? .CustomGreen : .gray)
                                                        .font(.system(size: 30))
                                                        .padding(10)
                                                        .background(medication.isTaken[0] ? Color.CustomGreen.opacity(0.1) : Color.gray.opacity(0.1))
                                                        .cornerRadius(30)
                                                    
                                                    Text(medication.isTaken[0] ? "복용\n완료" : "복용 전")
                                                        .frame(width: 70)
                                                        .multilineTextAlignment(.center)
                                                        .fixedSize()
                                                        .font(.medium16)
                                                        .foregroundColor(medication.isTaken[0] ? .CustomGreen : .black)
                                                }
                                                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                                            }
                                        }
                                        if viewModel.checkMinuteMedications(medication)[index] {
                                            Text("복용 시간이 30분 이상 지났습니다")
                                                .font(.regular14)
                                                .foregroundColor(Color(.red).opacity(0.8))
                                                .padding(.top, -20)
                                        }
                                    }
                                    
                                }
                                
                                Spacer()
                                
                                
                            }
                            .padding(.vertical)
                            
                            Divider()
                        }
                    }
                }
                .padding(.horizontal, 20)
            }
            .onAppear {
                viewModel.fetchTodayMedication()
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
                        Image(systemName: "pills.fill")
                            .foregroundColor(.black)
                    }
                }
            }
        }
    }
    
    func getTodayDateAndDayOfWeek() -> (month: String, day: String, dayOfWeek: String) {
        let currentDate = Date()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM"
        let month = dateFormatter.string(from: currentDate)
        
        dateFormatter.dateFormat = "dd"
        let day = dateFormatter.string(from: currentDate)
        
        
        let dayFormatter = DateFormatter()
        dayFormatter.dateFormat = "EEEE"
        let dayOfWeek = dayFormatter.string(from: currentDate)
        
        return (month, day, dayOfWeek)
    }
}

#Preview {
    MedicationMainView()
        .environmentObject(MedicationViewModel(dataSource: .shared))
}

