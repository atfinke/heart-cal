//
//  HealthManager.swift
//  Heart Cal
//
//  Created by Andrew Finke on 2/7/18.
//  Copyright © 2018 Andrew Finke. All rights reserved.
//

import HealthKit
import UIKit

class HealthManager {

    // MARK: - Types

    struct HeartRateMeasure {

        // MARK: - Properties

        let min: Int
        let max: Int
        let average: Int

        let startDate: Date
        let endDate: Date

        // MARK: - Initialization

        fileprivate init?(statistics: HKStatistics, startDate: Date, endDate: Date) {
            let unit = HKUnit.count().unitDivided(by: HKUnit.minute())

            guard let average = statistics.averageQuantity()?.doubleValue(for: unit),
                let min = statistics.minimumQuantity()?.doubleValue(for: unit),
                let max = statistics.maximumQuantity()?.doubleValue(for: unit) else {
                    return nil
            }

            self.min = Int(min)
            self.max = Int(max)
            self.average = Int(average)

            self.startDate = startDate
            self.endDate = endDate
        }
    }

    // MARK: - Properties

    private let healthStore = HKHealthStore()
    private let heartQuantityType: HKQuantityType = {
        guard let object = HKQuantityType.quantityType(forIdentifier: .heartRate) else {
            fatalError()
        }
        return object
    }()

    // MARK: - Methods

    func authorize(completion: @escaping (Bool, Error?) -> Void) {
        let set: Set = [heartQuantityType]
        healthStore.requestAuthorization(toShare: nil, read: set) { (success, error) in
            completion(success, error)
        }
    }

    func measure(between startDate: Date, and endDate: Date, completion: @escaping (HeartRateMeasure?) -> Void) {
        let predicate = HKQuery.predicateForSamples(withStart: startDate,
                                                    end: endDate,
                                                    options: [.strictStartDate, .strictEndDate])

        let query = HKStatisticsQuery(quantityType: heartQuantityType,
                                      quantitySamplePredicate: predicate,
                                      options: [.discreteAverage,
                                                .discreteMin,
                                                .discreteMax]) { (_, statistics, error) in

                                                    guard error == nil, let statistics = statistics else {
                                                        completion(nil)
                                                        return
                                                    }
                                                    let measure = HeartRateMeasure(statistics: statistics,
                                                                                   startDate: startDate,
                                                                                   endDate: endDate)

                                                    completion(measure)

        }
        healthStore.execute(query)
    }

}