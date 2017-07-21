//
//  EventFavoritesService.swift
//  Eurofurence
//
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation
import UserNotificationsUI
import ReactiveSwift
import Result

class EventFavoritesService {
	private let dataContext: DataContextProtocol
	private let scheduler = QueueScheduler(qos: .background, name: "org.eurofurence.app.EventFavoritesService")
	private var disposables = CompositeDisposable()
	private var eventFavoriteDisposbales = CompositeDisposable()
	private var _localNotifications: [UILocalNotification] = []
	private var localNotifications: [UILocalNotification] {
		get {
			return _localNotifications
		}
		set(notifications) {
			localNotificationStore.storeLocalNotifications(notifications)
			_localNotifications = notifications
		}
	}
	private let (singleFavoriteChangeSignal, singleFavoriteChangeObserver) = Signal<[EventFavorite], NoError>.pipe()
	private let mergedChangeSignal: Signal<[EventFavorite], NoError>
	/// Signal with events containing changed EventFavorites and an array with
	/// all EventFavorites on major changes (e.g. NavigationResolver).
	var changeSignal: Signal<[EventFavorite], NoError> {
		return mergedChangeSignal
	}

	private let localNotificationStore: LocalNotificationStore = KeyedLocalNotificationStore(name: "EventFavorites")
	private let timeService: TimeService = try! ServiceResolver.container.resolve()
	private let eventNotificationPreferences: EventNotificationPreferences = UserDefaultsEventNotificationPreferences.instance

	init(dataContext: DataContextProtocol) {
		self.dataContext = dataContext

		let (mergeSignal, mergeObserver) = Signal<Signal<[EventFavorite], NoError>, NoError>.pipe()
		mergedChangeSignal = mergeSignal.flatten(.merge)
		mergeObserver.send(value: singleFavoriteChangeSignal)
		mergeObserver.send(value: dataContext.EventFavorites.signal)
		mergeObserver.sendCompleted()

		localNotifications = localNotificationStore.loadLocalNotifications()

		disposables += dataContext.EventFavorites.signal.observe(on: scheduler).observeValues({
			[unowned self] (eventFavorites) in
			self.updateLocalNotifications(eventFavorites, offset: self.timeService.offset.value)
			self.observe(eventFavorites)
		})

		disposables += timeService.offset.signal.observe(on: scheduler).observeValues({
			[unowned self] (offset) in
			self.updateLocalNotifications(self.dataContext.EventFavorites.value, offset: offset)
		})

		disposables += eventNotificationPreferences.signal.observe(on: scheduler).observeValues({ _, _ in
			self.updateLocalNotifications(self.dataContext.EventFavorites.value, offset: self.timeService.offset.value)
		})
	}

	private func observe(_ eventFavorites: [EventFavorite]) {
		eventFavoriteDisposbales.dispose()
		eventFavoriteDisposbales = CompositeDisposable()
		eventFavorites.forEach({ (eventFavorite) in
			eventFavoriteDisposbales += eventFavorite.IsFavorite.signal.observe(on: scheduler).observeValues({ [unowned self] value in
				self.singleFavoriteChangeObserver.send(value: [eventFavorite])
				self.eventFavoriteDisposbales += self.dataContext.saveToStore(.Events).start()
				guard let event = eventFavorite.Event, self.eventNotificationPreferences.notificationsEnabled else { return }
				if value && event.StartDateTimeUtc > self.timeService.currentTime.value {
					self.scheduleLocalNotification(for: event, offset: self.timeService.offset.value)
				} else {
					self.cancelLocalNotifications(for: event)
				}
			})
		})
	}

	private func createLocalNotificaton(for event: Event, offset: TimeInterval = 0.0) -> UILocalNotification {
		let offsetDate = event.StartDateTimeUtc.addingTimeInterval(-1 * offset)
		let fireDate = offsetDate.addingTimeInterval(-1 * eventNotificationPreferences.notificationAheadInterval)
		let timeDelta = offsetDate.timeIntervalSince(Date())

		let localNotification = UILocalNotification()
		localNotification.fireDate = fireDate
		localNotification.alertAction = "Upcoming Favorite Event"
		localNotification.alertBody = "\(event.Title) will take place \(timeDelta.minutes >= 1.0 ? "in \(timeDelta.dhmString)" : "now") at \(event.ConferenceRoom?.Name ?? "someplace")"
		localNotification.userInfo = ["Event.Id": event.Id, "Event.LastChangeDateTimeUtc": event.LastChangeDateTimeUtc]

		return localNotification
	}

	/// Schedules a new notification for given event.
	///
	/// - Parameters:
	///     - event: event for which a notification should be scheduled
	///     - offset: interval the app is currently offset from actual local time
	func scheduleLocalNotification(for event: Event, offset: TimeInterval = 0.0) {
		let localNotification = createLocalNotificaton(for: event, offset: offset)
		localNotifications.append(localNotification)
		UIApplication.shared.scheduleLocalNotification(localNotification)
		print("Scheduled notification for event \(event.Title) [\(event.Id)]")
	}

	/// Cancels all notifications currently scheduled for given event.
	func cancelLocalNotifications(for event: Event) {
		var remainingNotifications: [UILocalNotification] = []
		localNotifications.forEach { notification in
			if let eventId = notification.userInfo?["Event.Id"] as? String, eventId == event.Id {
				UIApplication.shared.cancelLocalNotification(notification)
			} else {
				remainingNotifications.append(notification)
			}
		}

		print("Cancelled \(localNotifications.count - remainingNotifications.count) notification(s) for event \(event.Title) [\(event.Id)]")
		localNotifications = remainingNotifications
	}

	func cancelAllLocalNotifications() {
		localNotifications.forEach { (notification) in
			UIApplication.shared.cancelLocalNotification(notification)
		}
		localNotifications = []
	}

	/// Cancels all notifications of the EventFavoritesService category whose
	/// events have been removed and reschedules those with changed events.
	/// Note: This will also schedule new notifications for previously
	/// unscheduled favourite events!
	///
	/// - Parameters:
	///     - eventFavorites: array based on which updates should be performed
	///     - offset: interval the app is currently offset from actual local time
	func updateLocalNotifications(_ eventFavorites: [EventFavorite], offset: TimeInterval = 0.0) {
		guard eventNotificationPreferences.notificationsEnabled else {
			cancelAllLocalNotifications()
			return
		}

		var updatedNotifications: [UILocalNotification] = []
		// Adjusted for offset and ahead interval to filter by Event.StartDateTimeUtc
		let currentEventStartTime = Date(timeIntervalSinceNow: offset)
			.addingTimeInterval(eventNotificationPreferences.notificationAheadInterval)

		localNotifications.forEach { notification in
			if let eventId = notification.userInfo?["Event.Id"] as? String,
				let eventFavorite = eventFavorites.first(where: { $0.EventId == eventId }),
				let event = eventFavorite.Event, event.StartDateTimeUtc > currentEventStartTime {

				UIApplication.shared.cancelLocalNotification(notification)
				let updatedNotification = createLocalNotificaton(for: event, offset: offset)
				updatedNotifications.append(updatedNotification)
				UIApplication.shared.scheduleLocalNotification(notification)
			} else {
				UIApplication.shared.cancelLocalNotification(notification)
			}
		}

		eventFavorites.forEach { (eventFavorite) in
			if eventFavorite.IsFavorite.value, let event = eventFavorite.Event,
				event.StartDateTimeUtc > currentEventStartTime,
				!updatedNotifications.contains(where: { $0.userInfo?["Event.Id"] as? String == eventFavorite.EventId }) {

				let localNotification = createLocalNotificaton(for: event, offset: offset)
				updatedNotifications.append(localNotification)
				UIApplication.shared.scheduleLocalNotification(localNotification)
			}
		}

		localNotifications = updatedNotifications
	}

	deinit {
		disposables.dispose()
		eventFavoriteDisposbales.dispose()
	}
}
