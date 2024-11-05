//
//  DetailView.swift
//  Health-Assistant
//
//  Created by wonhoKim on 11/4/24.
//

//디테일뷰 더미
//타이틀 두고 내용을 마크다운으로 표현할수 있게
import SwiftUI
import MarkdownUI

struct ReportsDetailView: View {
    var report: HealthReport
    
    var body: some View {
        
        VStack {
            ScrollView{
                VStack{
                    //나중에 건강데이터 받아와서 마크다운으로 적용하기 일단 폼만 만들어놓기
                    //그래프는 데이터 받아온후 차트 활용해서
                    Markdown("""
                         # 건강 리포트
                         \(report.dateRange)
                         ___
                         """)
                    
                    Markdown(report.content)
                }
            }
            .padding()
            Spacer()
        }
        .navigationTitle(report.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                  //pdf 공유 로직 와야할곳
                }) {
                    Image(systemName: "square.and.arrow.up")
                        .font(.regular20)
                }
            }
        }
    }
}

#Preview {
    HealthListView()
}


