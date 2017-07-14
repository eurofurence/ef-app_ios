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

class NewsTableViewController: UITableViewController, UIViewControllerPreviewingDelegate {

	private var announcementsViewModel: AnnouncementsViewModel = try! ViewModelResolver.container.resolve()
	private var currentEventsViewModel: CurrentEventsViewModel = try! ViewModelResolver.container.resolve()
	private var timeService: TimeService = try! ServiceResolver.container.resolve()
	private var disposables = CompositeDisposable()

	@IBOutlet weak var lastSyncLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

		if traitCollection.forceTouchCapability == .available {
			registerForPreviewing(with: self, sourceView: view)
		}

        tableView.estimatedRowHeight = 70
        tableView.rowHeight = UITableViewAutomaticDimension

		tableView.register(UINib(nibName: "EventCell", bundle: nil), forCellReuseIdentifier: "EventCell")

        self.refreshControl?.addTarget(self, action: #selector(NewsTableViewController.refresh(_:)), for: UIControlEvents.valueChanged)

		disposables += lastSyncLabel.reactive.text <~ announcementsViewModel.TimeSinceLastSync.map({
			(timeSinceLastSync: TimeInterval) in
			if timeSinceLastSync > 0.0 {
				return "Last refreshed \(timeSinceLastSync.biggestUnitString) ago"
			}
			return "Last refreshed now"
		})

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

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(true)

		if let tabBarItem = self.navigationController?.tabBarItem {
			tabBarItem.badgeValue = nil
		}
	}

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)

		if let tabBarItem = self.navigationController?.tabBarItem {
			tabBarItem.badgeValue = nil
		}

		refreshControl?.endRefreshing()
	}

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
		/*
			0 - announcements
			1 - running events
			2 - upcoming events
		*/

		// TODO: Do we display a static message in case of empty sections or do we hide the sections?

        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		switch section {
		case 0:
			return max(1, announcementsViewModel.Announcements.value.count)
		case 1:
			return max(1, currentEventsViewModel.RunningEvents.value.count)
		case 2:
			return max(1, currentEventsViewModel.UpcomingEvents.value.count)
		default: // Header or unknown section
			return 0
		}
    }

	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String {
		// TODO: Externalise strings for i18n
		switch section {
		case 0:
			return "Announcements"
		case 1:
			return "Running Events"
		case 2:
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
		switch indexPath.section {
		case 0:
			if announcementsViewModel.Announcements.value.isEmpty {
				return tableView.dequeueReusableCell(withIdentifier: "NoAnnouncementsCell", for: indexPath)
			} else {
				let cell = tableView.dequeueReusableCell(withIdentifier: "AnnouncementCell", for: indexPath) as! AnnouncementCell
				cell.announcement = announcementsViewModel.Announcements.value[indexPath.row]
				return cell
			}
		case 1:
			if currentEventsViewModel.RunningEvents.value.isEmpty {
				return tableView.dequeueReusableCell(withIdentifier: "NoRunningEventsCell", for: indexPath)
			} else {
				let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath) as! EventCell
				cell.event = currentEventsViewModel.RunningEvents.value[indexPath.row]
				return cell
			}
		case 2:
			if currentEventsViewModel.UpcomingEvents.value.isEmpty {
				return tableView.dequeueReusableCell(withIdentifier: "NoUpcomingEventsCell", for: indexPath)
			} else {
				let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath) as! EventCell
				cell.event = currentEventsViewModel.UpcomingEvents.value[indexPath.row]
				return cell
			}
		default: // Unknown section or header
			return UITableViewCell()
		}
	}

	func getData(for indexPath: IndexPath) -> EntityBase? {
		let dataSource: [EntityBase]
		switch indexPath.section {
		case 0:
			dataSource = announcementsViewModel.Announcements.value
		case 1:
			dataSource = currentEventsViewModel.RunningEvents.value
		case 2:
			dataSource = currentEventsViewModel.UpcomingEvents.value
		default:
			return nil
		}

		if indexPath.row < dataSource.count {
			return dataSource[indexPath.row]
		} else {
			return nil
		}
	}

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		switch getData(for: indexPath) {
		case let announcement as Announcement:
			performSegue(withIdentifier: "AnnouncementDetailSegue", sender: announcement)
		case let event as Event:
			performSegue(withIdentifier: "EventDetailSegue", sender: event)
		default:
			break
		}
	}

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		guard let segueIdentifier = segue.identifier else { return }
		// Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
		switch segueIdentifier {
		case "AnnouncementDetailSegue":
            if let destinationVC = segue.destination as? NewsViewController, let announcement = sender as? Announcement {
                destinationVC.news = announcement
            }
		case "EventDetailSegue":
			if let destinationVC = segue.destination as? EventViewController, let event = sender as? Event {
				destinationVC.event = event
			}
		default:
			break
        }
    }

	// MARK: - Previewing

	func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
		guard let indexPath = tableView.indexPathForRow(at: location),
			let data = getData(for: indexPath) else { return nil }

		let viewController: UIViewController
		switch data {
		case let announcement as Announcement:
			guard let announcementViewController = storyboard?.instantiateViewController(withIdentifier: "AnnouncementDetail") as? NewsViewController else {
				return nil
			}
			announcementViewController.news = announcement
			viewController = announcementViewController
		case let event as Event:
			guard let eventViewController = storyboard?.instantiateViewController(withIdentifier: "EventDetail") as? EventViewController else {
				return nil
			}
			eventViewController.event = event
			viewController = eventViewController
		default:
			return nil
		}

		return viewController
	}

	func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
		show(viewControllerToCommit, sender: self)
	}

	deinit {
		disposables.dispose()
	}
}
