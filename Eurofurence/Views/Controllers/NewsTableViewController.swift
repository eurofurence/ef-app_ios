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

class NewsTableViewController: UITableViewController,
                               UIViewControllerPreviewingDelegate,
                               MessagesViewControllerDelegate,
                               AuthenticationStateObserver {
	@IBOutlet weak var favoritesOnlySegmentedControl: UISegmentedControl!
	@IBOutlet weak var lastSyncLabel: UILabel!

	private var announcementsViewModel: AnnouncementsViewModel = try! ViewModelResolver.container.resolve()
	private var currentEventsViewModel: CurrentEventsViewModel = try! ViewModelResolver.container.resolve()
	private var timeService: TimeService = try! ServiceResolver.container.resolve()
	private var disposables = CompositeDisposable()
    private var loggedInUser: User?

	private var announcements: [Announcement] = []
	private var runningEvents: [Event] = []
	private var upcomingEvents: [Event] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        EurofurenceApplication.shared.add(self)

		announcements = announcementsViewModel.Announcements.value
		runningEvents = currentEventsViewModel.RunningEvents.value
		upcomingEvents = currentEventsViewModel.UpcomingEvents.value

		if traitCollection.forceTouchCapability == .available {
			registerForPreviewing(with: self, sourceView: view)
		}

        tableView.estimatedRowHeight = 70
        tableView.rowHeight = UITableViewAutomaticDimension

		tableView.register(UINib(nibName: "EventCell", bundle: nil), forCellReuseIdentifier: "EventCell")
		tableView.register(UINib(nibName: "EventCell", bundle: nil), forCellReuseIdentifier: "EventCellWithoutBanner")

		tableView.register(UINib(nibName: "NewsSectionHeader", bundle: nil), forHeaderFooterViewReuseIdentifier: "NewsSectionHeader")

        self.refreshControl?.addTarget(self, action: #selector(NewsTableViewController.refresh(_:)), for: .valueChanged)

		disposables += lastSyncLabel.reactive.text <~ announcementsViewModel.TimeSinceLastSync.map({
			(timeSinceLastSync: TimeInterval) in
			if timeSinceLastSync > 0.0 {
				return "Last refreshed \(timeSinceLastSync.biggestUnitString) ago"
			}
			return "Last refreshed now"
		})

        disposables += announcementsViewModel.AnnouncementsEdits.signal.observeValues({
            [unowned self] edits in
			DispatchQueue.main.async {
				var edits = edits
				if self.announcements.count == 0 {
					edits.append(Edit<Announcement>.init(.deletion, value: Announcement(), destination: 0))
				} else if self.announcementsViewModel.Announcements.value.count == 0 {
					edits.append(Edit<Announcement>.init(.insertion, value: Announcement(), destination: 0))
				}
				self.announcements = self.announcementsViewModel.Announcements.value
				self.tableView.update(with: edits, in: 1)
            }
        })
        disposables += currentEventsViewModel.RunningEventsEdits.signal.observeValues({
            [unowned self] edits in
			DispatchQueue.main.async {
				var edits = edits
				if self.runningEvents.count == 0 {
					edits.append(Edit<Event>.init(.deletion, value: Event(), destination: 0))
				} else if self.currentEventsViewModel.RunningEvents.value.count == 0 {
					edits.append(Edit<Event>.init(.insertion, value: Event(), destination: 0))
				}
				self.runningEvents = self.currentEventsViewModel.RunningEvents.value
				self.tableView.update(with: edits, in: 2)
            }
        })
        disposables += currentEventsViewModel.UpcomingEventsEdits.signal.observeValues({
			[unowned self] edits in
            DispatchQueue.main.async {
				var edits = edits
				if self.upcomingEvents.count == 0 {
					edits.append(Edit<Event>.init(.deletion, value: Event(), destination: 0))
				} else if self.currentEventsViewModel.UpcomingEvents.value.count == 0 {
					edits.append(Edit<Event>.init(.insertion, value: Event(), destination: 0))
				}
				self.upcomingEvents = self.currentEventsViewModel.UpcomingEvents.value
				self.tableView.update(with: edits, in: 3)
            }
        })
        disposables += timeService.currentTime.signal.observeValues({
            [unowned self] value in
            DispatchQueue.main.async {
                if self.timeService.offset.value != 0.0 {
                    self.navigationItem.title = "News @ \(DateFormatters.hourMinute.string(from: value))"
                } else {
                    self.navigationItem.title = "News"
                }
            }
        })

        guard let refreshControl = refreshControl else { return }

        let refreshControlVisibilityDelegate = RefreshControlDataStoreDelegate(refreshControl: refreshControl)
        DataStoreRefreshController.shared.add(refreshControlVisibilityDelegate)
    }

	@IBAction func favoritesOnlyFilterChanged(_ sender: UISegmentedControl) {
		currentEventsViewModel.isFavoritesOnly = sender.selectedSegmentIndex == 1
		timeService.tick()
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

        return 4
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		switch section {
        case 0:
            return 1
		case 1:
			return max(1, announcements.count)
		case 2:
			return max(1, runningEvents.count)
		case 3:
			return max(1, upcomingEvents.count)
		default: // Header or unknown section
			return 0
		}
    }

	override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		guard let cell = tableView.dequeueReusableHeaderFooterView(withIdentifier: "NewsSectionHeader") as? NewsSectionHeader else { return nil }
		switch section {
		case 1:
			cell.sectionTitle = "Announcements"
			cell.isShowAll = announcementsViewModel.isShowAll
			cell.toggleShowAllAction = { cell in
				self.announcementsViewModel.isShowAll = cell.isShowAll
				self.timeService.tick()
			}
		case 2:
			cell.sectionTitle = "Running Events"
			cell.toggleShowAllAction = nil
		case 3:
			cell.sectionTitle = "Upcoming Events"
			cell.toggleShowAllAction = nil
		default: // Unknown section or header
			return nil
		}

		return cell
	}

	override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		switch section {
		case 1:
			return 35.0
		case 2:
			return 35.0
		case 3:
			return 35.0
		default: // Unknown section or header
			return 0.0
		}
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		switch indexPath.section {
        case 0:
            if let user = loggedInUser {
                let cell = tableView.dequeueReusableCell(withIdentifier: "LoggedInCell", for: indexPath) as! UnreadMessagesTableViewCell
                cell.showUserNameSynopsis("Welcome, \(user.username) (\(user.registrationNumber))")
                return cell
            } else {
                return tableView.dequeueReusableCell(withIdentifier: "LoginHintCell", for: indexPath)
            }
		case 1:
			if announcements.isEmpty {
				return tableView.dequeueReusableCell(withIdentifier: "NoAnnouncementsCell", for: indexPath)
			} else {
				let announcement = getData(for: indexPath) as? Announcement
				let cell = tableView.dequeueReusableCell(withIdentifier: "AnnouncementCell", for: indexPath) as! AnnouncementCell
				cell.announcement = announcement
				return cell
			}
		case 2:
			if runningEvents.isEmpty {
				return tableView.dequeueReusableCell(withIdentifier: "NoRunningEventsCell", for: indexPath)
			} else {
				let event = getData(for: indexPath) as? Event
				let cell = tableView.dequeueReusableCell(withIdentifier: event?.BannerImage != nil ? "EventCell" : "EventCellWithoutBanner", for: indexPath) as! EventCell
				cell.event = event
				return cell
			}
		case 3:
			if upcomingEvents.isEmpty {
				return tableView.dequeueReusableCell(withIdentifier: "NoUpcomingEventsCell", for: indexPath)
			} else {
				let event = getData(for: indexPath) as? Event
				let cell = tableView.dequeueReusableCell(withIdentifier: event?.BannerImage != nil ? "EventCell" : "EventCellWithoutBanner", for: indexPath) as! EventCell
				cell.event = event
				return cell
			}
		default: // Unknown section or header
			return UITableViewCell()
		}
	}

	func getData(for indexPath: IndexPath) -> EntityBase? {
		let dataSource: [EntityBase]
		switch indexPath.section {
		case 1:
			dataSource = announcements
		case 2:
			dataSource = runningEvents
		case 3:
			dataSource = upcomingEvents
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
        guard indexPath.section != 0 else {
            performSegue(withIdentifier: "showMessages", sender: self)
            return
        }

        switch getData(for: indexPath) {
		case let announcement as Announcement:
			performSegue(withIdentifier: "AnnouncementDetailSegue", sender: announcement)
		case let event as Event:
			performSegue(withIdentifier: "EventDetailSegue", sender: event)
		default:
			break
		}
	}

	// MARK: - Editing

	override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
		let rowData = getData(for: indexPath)

		switch rowData {
		case let event as Event:
			if let eventFavorite = event.EventFavorite {
				let actionTitle = (eventFavorite.IsFavorite.value) ? "Remove Favorite" : "Add Favorite"
				let favoriteAction = UITableViewRowAction(style: .default, title: actionTitle, handler: { (_, _) in
					eventFavorite.IsFavorite.swap(!eventFavorite.IsFavorite.value)
					tableView.isEditing = false
				})
				favoriteAction.backgroundColor = (eventFavorite.IsFavorite.value) ?
					UIColor.init(red: 0.75, green: 0.00, blue: 0.00, alpha: 1.0) :
					UIColor.init(red: 0.00, green: 0.75, blue: 0.00, alpha: 1.0)
				return [favoriteAction]
			}
		case let announcement as Announcement:
			let actionTitle = (announcement.IsRead) ? "Mark as Unread" : "Mark as Read"
			let readAction = UITableViewRowAction(style: .default, title: actionTitle, handler: { (_, _) in
				announcement.IsRead = !announcement.IsRead
				tableView.isEditing = false
				self.announcementsViewModel.saveAnnouncements()
			})
			readAction.backgroundColor = (announcement.IsRead) ?
				UIColor.lightGray :
				tableView.tintColor
			return [readAction]
		default:
			break
		}
		return nil
	}

	override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		let rowData = getData(for: indexPath)

		switch rowData {
		case is Event:
			return true
		case is Announcement:
			return true
		default:
			return false
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
            if let messages = segue.destination as? MessagesViewController {
                messages.messagesDelegate = self
            }
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

    // MARK: MessagesViewControllerDelegate

    func messagesViewControllerDidRequestDismissal(_ messagesController: MessagesViewController) {
        navigationController?.popToViewController(self, animated: true)
    }

    // MARK: AuthenticationStateObserver

    func loggedIn(as user: User) {
        loggedInUser = user

        let loginSectionIndex = IndexSet(integer: 0)
        tableView.reloadSections(loginSectionIndex, with: .automatic)
    }

}
