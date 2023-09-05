//
//  HeartrateFetcher.swift
//  GoHeartorGoHome Watch App
//
//  Created by Hidde van der Ploeg on 04/09/2023.
//

import Foundation
import HealthKit

final class HeartRateFetcher : ObservableObject {
    
    @Published var heartRate : Double = 0.0
    
    private let healthStore = HKHealthStore()
    private let heartRateQuantity = HKUnit(from: "count/min")
    
    @MainActor
    func startSensor() async {
        await autorizeHealthKit()
        startQuery(for: .heartRate)
    }
    
    func autorizeHealthKit() async {
        // Define the identifiers that create quantity type objects. (In our case: It's just HearRate)
        guard let quantityType = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate) else { return }
        let healthKitTypes: Set = [quantityType]
        
        do {
            // Requests permission to save and read the specified data types.
            try await healthStore.requestAuthorization(toShare: healthKitTypes, 
                                                       read: healthKitTypes)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func startQuery(for quantityTypeIdentifier: HKQuantityTypeIdentifier) {
        
        // The device we're using to collect the HeartRate
        let devicePredicate = HKQuery.predicateForObjects(from: [HKDevice.local()])
        
        // A query that returns changes to the HealthKit store, including a snapshot of new changes and continuous monitoring as a long-running query.
        let updateHandler: (HKAnchoredObjectQuery, [HKSample]?, [HKDeletedObject]?, HKQueryAnchor?, Error?) -> Void = { query, samples, deletedObjects, queryAnchor, error in
            // A sample that represents a quantity, including the value and the units.
            guard let samples = samples as? [HKQuantitySample] else { return }
            self.process(samples, type: quantityTypeIdentifier)
        }
        
        // It gives the ability to receive a snapshot of data, and then on subsequent calls, a snapshot of what has changed.
        let query = HKAnchoredObjectQuery(type: HKObjectType.quantityType(forIdentifier: quantityTypeIdentifier)!, predicate: devicePredicate, anchor: nil, limit: HKObjectQueryNoLimit, resultsHandler: updateHandler)
        query.updateHandler = updateHandler
        
        // query execution
        healthStore.execute(query)
    }
    
    
    private func process(_ samples: [HKQuantitySample], type: HKQuantityTypeIdentifier) {
        guard type == .heartRate else { return }
        
        for sample in samples {
            self.heartRate = sample.quantity.doubleValue(for: heartRateQuantity)
        }
    }
}

