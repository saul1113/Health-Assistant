//
//  MedicationDataSource.swift
//  Health-Assistant
//
//  Created by 김수민 on 11/10/24.
//

import Foundation
import SwiftData

final class MedicationDataSource {
    private let modelContainer: ModelContainer
    private let modelContext: ModelContext
    
    @MainActor
    static let shared = MedicationDataSource()
    
    @MainActor
    private init() {
        self.modelContainer = try! ModelContainer(for: Medication.self, configurations: ModelConfiguration(isStoredInMemoryOnly: false))
        self.modelContext = modelContainer.mainContext
    }
    
    func fetchMedications() -> [Medication] {
        do {
            let medications = try modelContext.fetch(FetchDescriptor<Medication>())
            return medications
        } catch {
            print("\(error)")
            return []
        }
    }
    
    func addMedication(_ medication: Medication) {
        modelContext.insert(medication)
            do {
                try modelContext.save()
            } catch {
                print("\(error)")
            }
        }
    
    func deldeteMedication(_ medication: Medication) {
        modelContext.delete(medication)
        do {
            try modelContext.save()
        } catch {
            print("\(error)")
        }
    }
    
    func updateMedication(_ medication: Medication) {
    }
}
