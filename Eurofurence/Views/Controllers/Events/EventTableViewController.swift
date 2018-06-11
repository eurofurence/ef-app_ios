//
//  EventTableViewController.swift
//  Eurofurence
//
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import UIKit
import Changeset
import ReactiveSwift

class EventTableViewController: UITableViewController, UISearchBarDelegate, UIViewControllerPreviewingDelegate {
	@IBOutlet weak var eventsBySegmentedControl: UISegmentedControl!
	@IBOutlet weak var favoritesOnlySegmentedControl: UISegmentedControl!
	@IBOutlet weak var searchBar: UISearchBar!

    var filteredSections: [EventsEntity] = []
    var filteredEvents: [[Event]] = []
	var isFavoritesOnly: Bool {
		return eventPreferences.doFilterEventFavorites
	}
	var isSearchActive: Bool {
		return !(searchBar.text?.isEmpty ?? true)
	}
	var isFiltered: Bool {
		return isSearchActive ||
			isFavoritesOnly
	}

	let viewModel: EventsViewModel = try! ViewModelResolver.container.resolve()
	let eventFavoriteSerivice: EventFavoritesService = try! ServiceResolver.container.resolve()
	private var eventPreferences: EventTablePreferences = UserDetailsEventTablePreferences(userDefaults: UserDefaults.standard)
	private var disposable = CompositeDisposable()

    override func viewDidLoad() {
        super.viewDidLoad()

		if traitCollection.forceTouchCapability == .available {
			registerForPreviewing(with: self, sourceView: tableView)
		}

        definesPresentationContext = true

		favoritesOnlySegmentedControl.selectedSegmentIndex = eventPreferences.doFilterEventFavorites ? 1 : 0
		eventsBySegmentedControl.selectedSegmentIndex = eventPreferences.eventGrouping.rawValue
		filtersChanged()

        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120.0
        tableView.sectionHeaderHeight = UITableViewAutomaticDimension
        tableView.estimatedSectionHeaderHeight = 100.0

		tableView.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "Background Tile"))

		let cancelSearchTap = UITapGestureRecognizer(target: tableView, action: #selector(self.tableView.endEditing(_:)))
		cancelSearchTap.cancelsTouchesInView = false
		tableView.addGestureRecognizer(cancelSearchTap)

        refreshControl?.addTarget(self, action: #selector(EventTableViewController.refresh(_:)), for: UIControlEvents.valueChanged)
        refreshControl?.backgroundColor = UIColor.clear

		tableView.register(UINib(nibName: "EventCell", bundle: nil), forCellReuseIdentifier: "EventCell")
		tableView.register(UINib(nibName: "EventCell", bundle: nil), forCellReuseIdentifier: "EventCellWithoutBanner")

        disposable += viewModel.Events.signal.observeResult({[unowned self] _ in
            DispatchQueue.main.async {
				self.filtersChanged()
                self.tableView.reloadData()
            }
        })

		disposable += eventFavoriteSerivice.changeSignal.observeValues({[unowned self] _ in
			DispatchQueue.main.async {
				self.filtersChanged()
				self.tableView.reloadData()
			}
		})

        guard let refreshControl = refreshControl else { return }

        let refreshControlVisibilityDelegate = RefreshControlDataStoreDelegate(refreshControl: refreshControl)
        DataStoreRefreshController.shared.add(refreshControlVisibilityDelegate)
	}

	// TODO: Pull into super class for all refreshable ViewControllers
	/// Initiates sync with API via refreshControl
	@objc func refresh(_ sender: AnyObject) {
		DataStoreRefreshController.shared.refreshStore()
	}

    override func viewWillAppear(_ animated: Bool) {
		// TODO: Observe viewModel.Events for changes while view is displayed
		// TODO: Update view by days based on TimeService ticks?
    }

	override func viewWillDisappear(_ animated: Bool) {
		refreshControl?.endRefreshing()
	}

	// MARK: - Table view data source

	func getData(for indexPath: IndexPath) -> EntityBase? {
		if isFiltered {
			if filteredEvents.count > indexPath.section && filteredEvents[indexPath.section].count > indexPath.row {
				return filteredEvents[indexPath.section][indexPath.row]
			} else {
				return nil
			}
		} else {
			switch eventsBySegmentedControl.selectedSegmentIndex {
			case 1:
				return viewModel.EventConferenceRooms.value[indexPath.section].Events[indexPath.row]
			case 2:
				return viewModel.EventConferenceTracks.value[indexPath.section].Events[indexPath.row]
			default:
				return viewModel.EventConferenceDays.value[indexPath.section].Events[indexPath.row]
			}
		}
	}

    override func numberOfSections(in tableView: UITableView) -> Int {
        if isFiltered {
            return max(filteredEvents.count, 1)
        }

        switch eventsBySegmentedControl.selectedSegmentIndex {
        case 1:
            return viewModel.EventConferenceRooms.value.count
        case 2:
            return viewModel.EventConferenceTracks.value.count
        default:
			return viewModel.EventConferenceDays.value.count
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if isFiltered {
			if filteredEvents.count == 0 && section == 0 {
				return 1
			} else {
				return filteredEvents[section].count
			}
		}

        switch eventsBySegmentedControl.selectedSegmentIndex {
        case 1:
            return viewModel.EventConferenceRooms.value[section].Events.count
        case 2:
            return viewModel.EventConferenceTracks.value[section].Events.count
        default:
			return viewModel.EventConferenceDays.value[section].Events.count
        }
    }

    private func addBorderUtility(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat, color: UIColor) -> CALayer {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: x, y: y, width: width, height: height)
        return border
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if isFiltered && filteredEvents.count == 0 {
			return tableView.dequeueReusableCell(withIdentifier: "NoSearchResults")!
		}

        guard let event = getData(for: indexPath) as? Event,
			let cell = tableView.dequeueReusableCell(withIdentifier: (event.BannerImage != nil ? "EventCell" : "EventCellWithoutBanner"), for: indexPath) as? EventCell  else { return UITableViewCell() }
		cell.event = event

        return cell
    }

    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView(frame: .zero)
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let  headerCell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell") as! EventHeaderCellTableViewCell

		if isFiltered {
			if filteredSections.count > 0 {
				switch filteredSections[section] {
				case let day as EventConferenceDay:
					headerCell.headerCellLabel.text = day.Name + "\n" + DateFormatters.dayMonthLong.string(from: day.Date)
				default:
					headerCell.headerCellLabel.text = filteredSections[section].Name
				}
			} else if let searchText = searchBar.text, !searchText.isEmpty {
				headerCell.headerCellLabel.text = "No Results for '\(searchText)'"
			} else if eventPreferences.doFilterEventFavorites {
				headerCell.headerCellLabel.text = "No Favorite Events"
			} else {
				headerCell.headerCellLabel.text = "No Results"
			}
		} else {
			switch eventsBySegmentedControl.selectedSegmentIndex {
			case 1:
				headerCell.headerCellLabel.text = viewModel.EventConferenceRooms.value[section].Name
			case 2:
				headerCell.headerCellLabel.text = viewModel.EventConferenceTracks.value[section].Name
			default:
				headerCell.headerCellLabel.text = viewModel.EventConferenceDays.value[section].Name + "\n" + DateFormatters.dayMonthLong.string(from: viewModel.EventConferenceDays.value[section].Date)
			}
		}

        return headerCell.contentView
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
	}

	// MARK: - Search

	@IBAction func favoritesOnlyFilterChanged(_ sender: UISegmentedControl) {
		eventPreferences.setFilterEventFavorites(sender.selectedSegmentIndex == 1)
		filtersChanged()
	}

	@IBAction func eventGroupingChanged(_ sender: UISegmentedControl) {
		eventPreferences.setEventGrouping(EventTableGrouping(rawValue: sender.selectedSegmentIndex) ?? EventTableGrouping.ByDays)
		filtersChanged()
	}

	func filtersChanged() {
		searchEvents(for: searchBar.text)
	}

	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		searchEvents(for: searchText)
	}

	func searchEvents(for searchText: String?) {
		filteredSections = []
		filteredEvents = []

		var searchResultSections: [EventsEntity] = []
		var searchResults: [[Event]] = []

		let data: [EventsEntity]
		switch eventsBySegmentedControl.selectedSegmentIndex {
		case 1:
			data = viewModel.EventConferenceRooms.value
		case 2:
			data = viewModel.EventConferenceTracks.value
		default:
			data = viewModel.EventConferenceDays.value
		}

		data.forEach({ (sectionEntity) in
			let filteredSectionEvents = sectionEntity.Events.filter({
				(!isSearchActive || $0.Title.localizedCaseInsensitiveContains(searchText ?? "")) &&
					(!isFavoritesOnly || $0.EventFavorite?.IsFavorite.value ?? false)
			})
			if filteredSectionEvents.count > 0 {
				searchResultSections.append(sectionEntity)
				searchResults.append(filteredSectionEvents)
			}
		})

		filteredSections = searchResultSections
		filteredEvents = searchResults
		tableView.reloadData()
	}

	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		searchBar.endEditing(true)
	}

	func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
		searchBar.setShowsCancelButton(true, animated: true)
	}

	func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
		searchBar.setShowsCancelButton(false, animated: true)
	}

	// MARK: - Navigation

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		performSegue(withIdentifier: "EventDetailSegue", sender: getData(for: indexPath))
	}

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
		if let destinationVC = segue.destination as? EventViewController,
				let event = sender as? Event,
				segue.identifier == "EventDetailSegue" {
			destinationVC.event = event
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
		default:
			return false
		}
	}

	// MARK: - Previewing

	func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
		guard let indexPath = tableView.indexPathForRow(at: location),
			let data = getData(for: indexPath) else {
				return nil
		}

        previewingContext.sourceRect = tableView.rectForRow(at: indexPath)

		let viewController: UIViewController
		switch data {
		case let event as Event:
			guard let eventViewController = storyboard?.instantiateViewController(withIdentifier: "EventDetailView") as? EventViewController else {
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
		disposable.dispose()
	}
}
