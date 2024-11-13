//
//  DocumentScanView.swift
//  Health-Assistant
//
//  Created by Soom on 11/13/24.
//

import SwiftUI
import VisionKit
import Vision

struct ScanData: Identifiable {
    let id = UUID()
    let text: String
}

struct DocumentScanView: UIViewControllerRepresentable {
    
    func updateUIViewController(_ uiViewController: VNDocumentCameraViewController, context: Context) {
    }
    
    
    class Cordinator: NSObject, VNDocumentCameraViewControllerDelegate {
        
    }
    func makeUIViewController(context: Context) -> VNDocumentCameraViewController {
        let viewController = VNDocumentCameraViewController()
        return viewController
    }
    typealias UIViewControllerType = VNDocumentCameraViewController
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
    }
}
