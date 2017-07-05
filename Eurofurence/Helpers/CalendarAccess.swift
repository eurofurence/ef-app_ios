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
	
	private let eventStore = EKEventStore()
	
	private init() {}
	
	private func requestAccess(_ completion: @escaping ((_ accessGranted: Bool) -> Void)) {
		eventStore.requestAccess(to: EKEntityType.event, completion: {
			(accessGranted: Bool, error: Error?) in
			
			if accessGranted == true {
				DispatchQueue.main.async(execute: {
					completion(true);
				})
			} else {
				DispatchQueue.main.async(execute: {
					completion(false);
				})
			}
		})
	}
	
	private func insert(_ ekEvent: EKEvent) {
		do {
			try self.eventStore.save(ekEvent, span: .thisEvent)

			let alert = UIAlertController(title: "Export succes", message: "Event exported succefuly", preferredStyle: UIAlertControllerStyle.alert)
			alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: nil))
			//self.presentViewController(alert, animated: true, completion: nil)
		} catch let specError as NSError {
			print("A specific error occurred: \(specError)")
		} catch {
			print("An error occurred")
		}
	}
	
	/**
	Attempts to insert given event into the user's calendar.
	Will ask for permission on first attempt and fail silently thereafter.
	- Parameter event: Event for which to create and insert a calendar entry
	*/
	func insert(event: Event) {
		let ekEvent = EKEvent(eventStore: eventStore.self)
		ekEvent.title = event.Title;
		ekEvent.notes = event.Description;
		ekEvent.location = event.ConferenceRoom?.Name;
		ekEvent.startDate = event.StartDateTimeUtc;
		ekEvent.endDate = event.EndDateTimeUtc;
		ekEvent.addAlarm(EKAlarm(absoluteDate: ekEvent.startDate.addingTimeInterval( -30 * 60)));
		ekEvent.calendar = self.eventStore.defaultCalendarForNewEvents;
		
		let status = EKEventStore.authorizationStatus(for: EKEntityType.event)
		switch (status) {
		case EKAuthorizationStatus.notDetermined:
			requestAccess() { accessGranted in
				if (accessGranted) {
					self.insert(ekEvent);
				}
			}
		case EKAuthorizationStatus.authorized:
			insert(ekEvent)
		case EKAuthorizationStatus.restricted, EKAuthorizationStatus.denied:
			break
		}
	}
}
