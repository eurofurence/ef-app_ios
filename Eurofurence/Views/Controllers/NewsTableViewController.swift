//
//  HomeViewController.swift
//  Eurofurence
//
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Result
import ReactiveCocoa
import ReactiveSwift
import UIKit
import Changeset

struct RefreshControlDataStoreDelegate: DataStoreRefreshDelegate {

    var refreshControl: UIRefreshControl

    func dataStoreRefreshDidBegin() {
        refreshControl.beginRefreshing()
    }

    func dataStoreRefreshDidFinish() {
        refreshControl.endRefreshing()
    }

    func dataStoreRefreshDidProduceProgress(_ progress: Progress) {

    }

    func dataStoreRefreshDidFailWithError(_ error: Error) {
        refreshControl.endRefreshing()
    }

}

class NewsTableViewController: UITableViewController {

	private var announcementsViewModel: AnnouncementsViewModel = try! ViewModelResolver.container.resolve()
	private var currentEventsViewModel: CurrentEventsViewModel = try! ViewModelResolver.container.resolve()
	private var timeService: TimeService = try! ServiceResolver.container.resolve()
	private var disposables = CompositeDisposable()

    override func viewDidLoad() {
        super.viewDidLoad()

		tableView.backgroundColor = UIColor.black
        tableView.estimatedRowHeight = 70
        tableView.rowHeight = UITableViewAutomaticDimension

        self.refreshControl?.addTarget(self, action: #selector(NewsTableViewController.refresh(_:)), for: UIControlEvents.valueChanged)

        guard let refreshControl = refreshControl else { return }

        let refreshControlVisibilityDelegate = RefreshControlDataStoreDelegate(refreshControl: refreshControl)
        DataStoreRefreshController.shared.add(refreshControlVisibilityDelegate)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        // Reset the application badge because all announcements can be assumed seen
        UIApplication.shared.applicationIconBadgeNumber = 0
        UIApplication.shared.cancelAllLocalNotifications()
    }

	// TODO: Pull into super class for all refreshable ViewControllers
    /// Initiates sync with API via refreshControl
    func refresh(_ sender: AnyObject) {
		DataStoreRefreshController.shared.refreshStore()
    }

    func notifyAnnouncements(_ announcements: [Announcement]) {
        UIApplication.shared.applicationIconBadgeNumber = 0
        if UserSettings.NotifyOnAnnouncement.currentValueOrDefault() {
            for announcement in announcements {
				let notification = UILocalNotification()
				notification.alertBody = announcement.Title
				notification.timeZone = TimeZone(abbreviation: "UTC")
				notification.fireDate = announcement.ValidFromDateTimeUtc
				notification.soundName = UILocalNotificationDefaultSoundName
				notification.userInfo = ["Announcement": announcement ]
				notification.applicationIconBadgeNumber = UIApplication.shared.applicationIconBadgeNumber + 1

				UIApplication.shared.presentLocalNotificationNow(notification)
            }
        } else if announcements.count > 0 {
            UIApplication.shared.applicationIconBadgeNumber = announcements.count
        }

        if let tabBarItem = self.navigationController?.tabBarItem, announcements.count > 0 {
            tabBarItem.badgeValue = String(announcements.count)
        }
	}

	func getLastRefreshString(_ lastRefresh: Date) -> String {
		// TODO: Externalise strings for i18n
		let lastUpdateSeconds = -1 * Int(lastRefresh.timeIntervalSinceNow)
		let lastUpdateMinutes = Int(lastUpdateSeconds / 60)
		let lastUpdateHours = Int(lastUpdateMinutes / 60)
		let lastUpdateDays = Int(lastUpdateHours / 24)
		let lastUpdateWeeks = Int(lastUpdateDays / 7)
		let lastUpdateYears = Int(lastUpdateWeeks / 52)

		if lastUpdateYears == 1 {
			return "Last refresh 1 year ago"
		} else if lastUpdateYears > 1 {
			return "Last refresh " + String(lastUpdateYears) + " years ago"
		} else if lastUpdateWeeks == 1 {
			return "Last refresh 1 week ago"
		} else if lastUpdateWeeks > 1 {
			return "Last refresh " + String(lastUpdateWeeks) + " weeks ago"
		} else if lastUpdateDays == 1 {
			return "Last refresh 1 day ago"
		} else if lastUpdateDays > 1 {
			return "Last refresh " + String(lastUpdateDays) + " days ago"
		} else if lastUpdateHours == 1 {
			return "Last refresh 1 hour ago"
		} else if lastUpdateHours > 1 {
			return "Last refresh " + String(lastUpdateHours) + " hours ago"
		} else if lastUpdateMinutes == 1 {
			return "Last refresh 1 minute ago"
		} else if lastUpdateMinutes > 1 {
			return "Last refresh " + String(lastUpdateMinutes) + " minutes ago"
		} else if lastUpdateSeconds == 1 {
			return "Last refresh 1 second ago"
		} else {
			return "Last refresh " + String(lastUpdateSeconds) + " seconds ago"
		}
	}

    override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()

		if !disposables.isDisposed {
			disposables.dispose()
		}
		disposables = CompositeDisposable()
	}

	override func viewWillAppear(_ animated: Bool) {
		if !disposables.isDisposed {
			disposables.dispose()
		}
		disposables = CompositeDisposable()
		disposables += announcementsViewModel.Announcements.signal.observeValues({
			[weak self] _ in
			guard let strongSelf = self else { return }
			DispatchQueue.main.async {
				strongSelf.tableView.reloadData()
			}
		})
		disposables += currentEventsViewModel.RunningEvents.signal.observeValues({
			[weak self] _ in
			guard let strongSelf = self else { return }
			DispatchQueue.main.async {
				strongSelf.tableView.reloadData()
			}
		})
		disposables += currentEventsViewModel.UpcomingEvents.signal.observeValues({
			[weak self] _ in
			guard let strongSelf = self else { return }
			DispatchQueue.main.async {
				strongSelf.tableView.reloadData()
			}
		})
		disposables += timeService.currentTime.signal.observeValues({
			[weak self] value in
			guard let strongSelf = self else { return }
			DispatchQueue.main.async {
				if strongSelf.timeService.offset != 0.0 {
					strongSelf.navigationItem.title = "News @ \(DateFormatters.hourMinute.string(from: value))"
				} else {
					strongSelf.navigationItem.title = "News"
				}
			}
		})

		if let tabBarItem = self.navigationController?.tabBarItem {
			tabBarItem.badgeValue = nil
		}
	}

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)

		if let tabBarItem = self.navigationController?.tabBarItem {
			tabBarItem.badgeValue = nil
		}
	}

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
		/*
			0 - header image and inbox notification
			1 - personal inbox
			2 - announcements
			3 - running events
			4 - upcoming events
		*/

		// TODO: Do we display a static message in case of empty sections or do we hide the sections?

        return 5
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		switch section {
		case 1:
			// TODO: Check for state of inbox
			return 1
		case 2:
			return max(1, announcementsViewModel.Announcements.value.count)
		case 3:
			return max(1, currentEventsViewModel.RunningEvents.value.count)
		case 4:
			return max(1, currentEventsViewModel.UpcomingEvents.value.count)
		default: // Header or unknown section
			return 0
		}
    }

	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String {
		// TODO: Externalise strings for i18n
		switch section {
		case 2:
			return "Announcements"
		case 3:
			return "Running Events"
		case 4:
			return "Upcoming Events"
		default: // Unknown section or header
			return ""
		}
	}

	override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		// No title, no visible section header
		return self.tableView(tableView, titleForHeaderInSection: section).isEmpty ? 0.0 : 20.0
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if indexPath.section == 0 {
			let cell = tableView.dequeueReusableCell(withIdentifier: "NewsHeaderTableViewCell", for: indexPath) as! NewsHeaderTableViewCell
			cell.newsLastRefreshLabel.text = getLastRefreshString(UserSettings.LastSyncDate.currentValueOrDefault())
			return cell
		} else if indexPath.section == 2 {
			if announcementsViewModel.Announcements.value.isEmpty {
				return tableView.dequeueReusableCell(withIdentifier: "NoAnnouncementsCell", for: indexPath)
			} else {
				let cell = tableView.dequeueReusableCell(withIdentifier: "AnnouncementCell", for: indexPath) as! AnnouncementCell
				cell.announcement = announcementsViewModel.Announcements.value[indexPath.row]
				return cell
			}
		} else if indexPath.section == 3 {
			if currentEventsViewModel.RunningEvents.value.isEmpty {
				return tableView.dequeueReusableCell(withIdentifier: "NoRunningEventsCell", for: indexPath)
			} else {
				let cell = tableView.dequeueReusableCell(withIdentifier: "SimpleEventCell", for: indexPath) as! SimpleEventCell
				cell.event = currentEventsViewModel.RunningEvents.value[indexPath.row]
				return cell
			}
		} else if indexPath.section == 4 {
			if currentEventsViewModel.UpcomingEvents.value.isEmpty {
				return tableView.dequeueReusableCell(withIdentifier: "NoUpcomingEventsCell", for: indexPath)
			} else {
				let cell = tableView.dequeueReusableCell(withIdentifier: "SimpleEventCell", for: indexPath) as! SimpleEventCell
				cell.event = currentEventsViewModel.UpcomingEvents.value[indexPath.row]
				return cell
			}
		} else {
				return tableView.dequeueReusableCell(withIdentifier: "NoAnnouncementsCell", for: indexPath)
		}
	}

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		guard let segueIdentifier = segue.identifier, let cell = sender as? UITableViewCell else {
			return
		}
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
		switch segueIdentifier {
		case "AnnouncementDetailSegue" :
            if let destinationVC = segue.destination as? NewsViewController, let cell = cell as? AnnouncementCell, let announcement = cell.announcement {
                destinationVC.news = announcement
            }
		case "EventDetailSegue":
			if let destinationVC = segue.destination as? EventViewController, let cell = cell as? SimpleEventCell, let event = cell.event {
				destinationVC.event = event
			}
		default:
			break
        }
    }

	deinit {
		disposables.dispose()
	}
}
