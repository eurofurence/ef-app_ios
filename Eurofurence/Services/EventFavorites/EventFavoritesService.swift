//
//  EventFavoritesService.swift
//  Eurofurence
//
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation
import UserNotificationsUI
import ReactiveSwift

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
			print("There are currently \(_localNotifications.count) scheduled favorite event notifications.")
		}
	}

	private let localNotificationStore: LocalNotificationStore = KeyedLocalNotificationStore(name: "EventFavorites")
	private let timeService: TimeService = try! ServiceResolver.container.resolve()

	init(dataContext: DataContextProtocol) {
		self.dataContext = dataContext

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
	}

	private func observe(_ eventFavorites: [EventFavorite]) {
		eventFavoriteDisposbales.dispose()
		eventFavoriteDisposbales = CompositeDisposable()
		eventFavorites.forEach({ (eventFavorite) in
			eventFavoriteDisposbales += eventFavorite.IsFavorite.signal.observe(on: scheduler).observeValues({ [unowned self] value in
				guard let event = eventFavorite.Event else { return }
				if value && event.StartDateTimeUtc > self.timeService.currentTime.value {
					self.scheduleLocalNotification(for: event, offset: self.timeService.offset.value)
				} else {
					self.cancelLocalNotifications(for: event)
				}
				self.eventFavoriteDisposbales += self.dataContext.saveToStore(.Events).start()
			})
		})
	}

	private func createLocalNotificaton(for event: Event, offset: TimeInterval = 0.0) -> UILocalNotification {
		let fireDate = event.StartDateTimeUtc.addingTimeInterval(-1 * offset)
		let timeDelta = fireDate.timeIntervalSince(Date().addingTimeInterval(offset))

		let localNotification = UILocalNotification()
		localNotification.fireDate = fireDate
		localNotification.alertAction = "Upcoming Favorite Event"
		localNotification.alertBody = "\(event.Title) will take place \(timeDelta.minutes >= 1.0 ? "in \(timeDelta.dhmString)" : "now") at \(event.ConferenceRoom?.Name ?? "somewhere")"
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

	/// Cancels all notifications of the EventFavoritesService category whose
	/// events have been removed and reschedules those with changed events.
	/// Note: This will also schedule new notifications for previously
	/// unscheduled favourite events!
	///
	/// - Parameters:
	///     - eventFavorites: array based on which updates should be performed
	///     - offset: interval the app is currently offset from actual local time
	func updateLocalNotifications(_ eventFavorites: [EventFavorite], offset: TimeInterval = 0.0) {
		var updatedNotifications: [UILocalNotification] = []
		let currentTime = Date(timeIntervalSinceNow: offset)

		localNotifications.forEach { notification in
			if let eventId = notification.userInfo?["Event.Id"] as? String,
				let eventFavorite = eventFavorites.first(where: { $0.EventId == eventId }),
				let event = eventFavorite.Event, event.StartDateTimeUtc > currentTime {

				if let lastChangeDate = notification.userInfo?["Event.LastChangeDateTimeUtc"] as? Date, (lastChangeDate < event.LastChangeDateTimeUtc || offset != 0.0) {

					UIApplication.shared.cancelLocalNotification(notification)
					let updatedNotification = createLocalNotificaton(for: event, offset: offset)
					updatedNotifications.append(updatedNotification)
					UIApplication.shared.scheduleLocalNotification(notification)
				} else {
					updatedNotifications.append(notification)
				}
			} else {
				UIApplication.shared.cancelLocalNotification(notification)
			}
		}

		eventFavorites.forEach { (eventFavorite) in
			if eventFavorite.IsFavorite.value, let event = eventFavorite.Event,
				event.StartDateTimeUtc > currentTime,
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
