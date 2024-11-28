//
//  MedicationCaptureView.swift
//  Health-Assistant
//
//  Created by Soom on 11/11/24.
//

import SwiftUI
import Vision

struct MedicationCaptureView: View {
    @State private var recognizedText: String = "스캔할 문서를 보여주세요"
    var body: some View {
        NavigationStack {
            ZStack {
                ScannerView(recognizedText: $recognizedText)
                    .ignoresSafeArea(edges: .top)
                VStack {
                    NavigationLink {
                    } label: {
                        Text("보고서 생성")
                            .padding(10)
                            .foregroundStyle(.white)
                            .background (Color.customGreen, in: RoundedRectangle(cornerRadius: 10))
                    }
                    ScrollView {
                        Text(recognizedText)
                            .padding()
                            .background(.ultraThinMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .padding()
                    }
                    Spacer()
                }
            }
        }
    }
}

#Preview {
    MedicationCaptureView()
}
