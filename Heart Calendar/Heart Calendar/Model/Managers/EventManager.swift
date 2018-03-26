//
//  EventManager.swift
//  Heart Cal
//
//  Created by Andrew Finke on 2/7/18.
//  Copyright © 2018 Andrew Finke. All rights reserved.
//

import UIKit
import EventKit

class EventManager {

    // MARK: - Types

    struct Event {
        let title: String
        let startDate: Date
        let endDate: Date
        let calendarColor: UIColor
    }

    struct Calendar {

        fileprivate let calendar: EKCalendar

        var title: String {
            return calendar.title
        }
        var identifier: String {
            return calendar.calendarIdentifier
        }
        var color: UIColor {
            return UIColor(cgColor: calendar.cgColor)
        }

        init(_ calendar: EKCalendar) {
            self.calendar = calendar
        }
    }

    // MARK: - Properties

    private let eventStore = EKEventStore()
    private var isAuthenticated = false

    // MARK: - Methods

    func authorize(completion: @escaping (Bool, Error?) -> Void) {
        eventStore.requestAccess(to: .event) { (success, error) in
            self.isAuthenticated = true
            completion(success, error)
        }
    }

    func calendars() -> [Calendar] {
        return eventStore.calendars(for: .event).map { Calendar($0) }
    }

    func events(between startDate: Date, and endDate: Date) -> [Event] {
        var calendarIdentifiers = PreferencesManager.shared.calendarIdentifiers
        if calendarIdentifiers == nil {
            calendarIdentifiers = calendars().map { $0.calendar.calendarIdentifier }
            PreferencesManager.shared.calendarIdentifiers = calendarIdentifiers
        }

        guard let calendarIDs = calendarIdentifiers, !calendarIDs.isEmpty else { return [] }
        let selectedCalendars = calendars()
            .map({ $0.calendar })
            .filter({ calendarIDs.contains($0.calendarIdentifier) })

        let predicate = eventStore.predicateForEvents(withStart: startDate,
                                                      end: endDate,
                                                      calendars: selectedCalendars)
        let storeEvents = eventStore.events(matching: predicate)

        return storeEvents.map {
            return Event(title: $0.title,
                         startDate: $0.startDate,
                         endDate: $0.endDate,
                         calendarColor: UIColor(cgColor: $0.calendar.cgColor))

        }
    }
}