//
//  OCRView.swift
//  Health-Assistant
//
//  Created by Soom on 11/13/24.
//

import SwiftUI
import Vision
import UIKit

struct OCRView: View {
    @State private var recognizedText: String = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Recognized Text:")
                ScrollView {
                    Text(recognizedText)
                        .padding()
                }
                .frame(height: 300)
                Button(action: {
                    recognizeTextFromImage(image: UIImage(systemName: "person.fill")!)
                }) {
                    Text("Start OCR")
                }
            }
            .padding()
        }
    }
    
    func recognizeTextFromImage(image: UIImage) {
        guard let cgImage = image.cgImage else { return }
        
        let request = VNRecognizeTextRequest { (request, error) in
            if let error = error {
                print("Error recognizing text: \(error)")
                return
            }
            
            if let observations = request.results as? [VNRecognizedTextObservation] {
                let recognizedStrings = observations.compactMap { $0.topCandidates(1).first?.string }
                DispatchQueue.main.async {
                    self.recognizedText = recognizedStrings.joined(separator: "\n")
                }
            }
        }
        
        request.recognitionLevel = .accurate
        request.recognitionLanguages = ["en-US", "ko-KR"]
        
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try handler.perform([request])
            } catch {
                print("Failed to perform OCR: \(error)")
            }
        }
    }
}
#Preview {
    OCRView()
}
