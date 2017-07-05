//
//  CalendarAccess.swift
//  Eurofurence
//
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation
import EventKit
import UIKit

/**
Export Events to the iOS calendar using EventKit.
*/
class CalendarAccess {
	static let instance = CalendarAccess()
	
	/// Checks whether calendar access has been denied.
	var isDenied: Bool {
		let status = EKEventStore.authorizationStatus(for: EKEntityType.event)
		switch (status) {
		case EKAuthorizationStatus.notDetermined, EKAuthorizationStatus.authorized:
			return false
		case EKAuthorizationStatus.restricted, EKAuthorizationStatus.denied:
			return true
		}
	}
	
	private var eventStore = EKEventStore()
	
	private init() {}
	
	private func requestAccess(_ completion: @escaping ((_ accessGranted: Bool) -> Void)) {
		eventStore.requestAccess(to: EKEntityType.event) { (accessGranted, _) in
            DispatchQueue.main.async {
                completion(accessGranted)
            }
		}
	}
	
	/**
	Attempts to insert given event into the user's calendar.
	Will ask for permission on first attempt and fail silently thereafter.
	- Parameter event: Event for which to create and insert a calendar entry
	*/
	func insert(event: Event) {
        verifyEventPermissions { (authorized) in
            if authorized {
                self.createAndInsertEvent(event)
            }
        }
	}

    private func verifyEventPermissions(_ completionHandler: @escaping (_ authorized: Bool) -> Void) {
        switch EKEventStore.authorizationStatus(for: EKEntityType.event) {
        case .authorized:
            completionHandler(true)

        case .notDetermined:
            requestAccess(completionHandler)

        default:
            completionHandler(false)
        }
    }

    private func createAndInsertEvent(_ event: Event) {
        performPermissionsChangedWorkroundIfNecessary()
        let eventToInsert = makeEvent(for: event)

        do {
            try eventStore.save(eventToInsert, span: .thisEvent)
        } catch let specError as NSError {
            print("A specific error occurred: \(specError)")
        } catch {
            print("An error occurred")
        }
    }

    private func performPermissionsChangedWorkroundIfNecessary() {
        let calendar: EKCalendar? = eventStore.defaultCalendarForNewEvents
        if calendar == nil {
            eventStore = EKEventStore()
        }
    }

    private func makeEvent(for event: Event) -> EKEvent {
        let ekEvent = EKEvent(eventStore: eventStore)
        ekEvent.title = event.Title;
        ekEvent.notes = event.Description;
        ekEvent.location = event.ConferenceRoom?.Name;
        ekEvent.startDate = event.StartDateTimeUtc;
        ekEvent.endDate = event.EndDateTimeUtc;
        ekEvent.addAlarm(EKAlarm(absoluteDate: ekEvent.startDate.addingTimeInterval( -30 * 60)));
        ekEvent.calendar = self.eventStore.defaultCalendarForNewEvents;

        return ekEvent
    }

}
