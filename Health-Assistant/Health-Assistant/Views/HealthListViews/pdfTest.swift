////
////  pdfTest.swift
////  Health-Assistant
////
////  Created by wonhoKim on 11/6/24.
////
//
//pdf 기능 테스트위한 뷰입니다 필요 없을떄 지울게요 
//import SwiftUI
//
//struct pdfTest: View {
//    var body: some View {
//        ShareLink("Export PDF", item: render())
//    }
//
//    @MainActor
//    func render() -> URL {
//        // 1: Render Hello World with some modifiers
//        let renderer = ImageRenderer(content:
//            Text("Hello, world!")
//                .font(.largeTitle)
//                .foregroundStyle(.white)
//                .padding()
//                .background(.blue)
//                .clipShape(Capsule())
//        )
//
//        // 2: Save it to our documents directory
//        let url = FileManager.default.temporaryDirectory.appendingPathComponent("output.pdf")
//        
//        // 3: Start the rendering process
//        renderer.render { size, context in
//            // 4: Tell SwiftUI our PDF should be the same size as the views we're rendering
//            var box = CGRect(x: 0, y: 0, width: size.width, height: size.height)
//
//            // 5: Create the CGContext for our PDF pages
//            guard let pdf = CGContext(url as CFURL, mediaBox: &box, nil) else {
//                print("Could not create PDF context.")
//                return
//            }
//
//            // 6: Start a new PDF page
//            pdf.beginPDFPage(nil)
//
//            // 7: Render the SwiftUI view data onto the page
//            context(pdf)
//
//            // 8: End the page and close the file
//            pdf.endPDFPage()
//            pdf.closePDF()
//        }
//
//        // 9: Check if file creation was successful and return URL
//        if FileManager.default.fileExists(atPath: url.path) {
//            print("PDF successfully created at \(url)")
//            return url
//        } else {
//            print("Failed to create PDF.")
//            return URL(fileURLWithPath: "")
//        }
//    }
//}
