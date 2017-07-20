//
//  EventTableViewController.swift
//  Eurofurence
//
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import UIKit
import Changeset
import ReactiveSwift

class EventTableViewController: UITableViewController, UISearchResultsUpdating, UISearchBarDelegate, UIViewControllerPreviewingDelegate {
    let searchController = UISearchController(searchResultsController: nil)
	var filteredSections: [EntityBase] = []
    var filteredEvents: [[Event]] = []

	let viewModel: EventsViewModel = try! ViewModelResolver.container.resolve()
	private var disposable = CompositeDisposable()

    override func viewDidLoad() {
        super.viewDidLoad()

		if traitCollection.forceTouchCapability == .available {
			registerForPreviewing(with: self, sourceView: view)
		}

		configureSearchController()

        definesPresentationContext = true
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120.0
        tableView.sectionHeaderHeight = UITableViewAutomaticDimension
        tableView.estimatedSectionHeaderHeight = 100.0
        tableView.backgroundColor =  UIColor(red: 35/255.0, green: 36/255.0, blue: 38/255.0, alpha: 1.0)
        refreshControl?.addTarget(self, action: #selector(EventTableViewController.refresh(_:)), for: UIControlEvents.valueChanged)
        refreshControl?.backgroundColor = UIColor.clear

		tableView.register(UINib(nibName: "EventCell", bundle: nil), forCellReuseIdentifier: "EventCell")
		tableView.register(UINib(nibName: "EventCell", bundle: nil), forCellReuseIdentifier: "EventCellWithoutBanner")

        disposable += viewModel.Events.signal.observeResult({[unowned self] _ in
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })

        guard let refreshControl = refreshControl else { return }

        let refreshControlVisibilityDelegate = RefreshControlDataStoreDelegate(refreshControl: refreshControl)
        DataStoreRefreshController.shared.add(refreshControlVisibilityDelegate)
	}

	private func configureSearchController() {
		searchController.searchBar.showsScopeBar = false
		searchController.searchResultsUpdater = self
		searchController.dimsBackgroundDuringPresentation = false
		searchController.searchBar.delegate = self
		searchController.searchBar.tintColor = UIColor.white
		searchController.searchBar.scopeButtonTitles = ["Day", "Room", "Track"]

		tableView.tableHeaderView = searchController.searchBar
	}

	// TODO: Pull into super class for all refreshable ViewControllers
	/// Initiates sync with API via refreshControl
	func refresh(_ sender: AnyObject) {
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
		if searchController.isActive && searchController.searchBar.text != "" {
			return self.filteredEvents[indexPath.section][indexPath.row]
		} else {
			switch self.searchController.searchBar.selectedScopeButtonIndex {
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
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredEvents.count
        }

        switch searchController.searchBar.selectedScopeButtonIndex {
        case 1:
            return viewModel.EventConferenceRooms.value.count
        case 2:
            return viewModel.EventConferenceTracks.value.count
        default:
			return viewModel.EventConferenceDays.value.count
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if searchController.isActive && searchController.searchBar.text != "" {
			return filteredEvents[section].count
		}

        switch searchController.searchBar.selectedScopeButtonIndex {
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

		if searchController.isActive && searchController.searchBar.text != "" {
			switch filteredSections[section] {
			case let room as EventConferenceRoom:
				headerCell.headerCellLabel.text = room.Name
			case let track as EventConferenceTrack:
				headerCell.headerCellLabel.text = track.Name
			case let day as EventConferenceDay:
				headerCell.headerCellLabel.text = day.Name + "\n" + DateFormatters.dayMonthLong.string(from: day.Date)
			default:
				// This should not be possible, but we try to handle it gracefully nevertheless.
				headerCell.headerCellLabel.text = "Other"
			}
		} else {
			switch self.searchController.searchBar.selectedScopeButtonIndex {
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

    // MARK: - UISearchBarDelegate

    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
		updateSearchResults(for: searchController)
        self.tableView.reloadData()
	}

	// MARK: - UISearchResultsUpdating

	func updateSearchResults(for searchController: UISearchController) {
		guard let searchText = searchController.searchBar.text else {
			filteredSections = []
			filteredEvents = []
			return
		}

		var searchResultSections: [EntityBase] = []
		var searchResults: [[Event]] = []

		switch self.searchController.searchBar.selectedScopeButtonIndex {
		case 1:
			viewModel.EventConferenceRooms.value.forEach({ (sectionEntity) in
				let filteredSectionEvents = sectionEntity.Events.filter({ $0.Title.contains(searchText) })
				if filteredSectionEvents.count > 0 {
					searchResultSections.append(sectionEntity)
					searchResults.append(filteredSectionEvents)
				}
			})
		case 2:
			viewModel.EventConferenceTracks.value.forEach({ (sectionEntity) in
				let filteredSectionEvents = sectionEntity.Events.filter({ $0.Title.contains(searchText) })
				if filteredSectionEvents.count > 0 {
					searchResultSections.append(sectionEntity)
					searchResults.append(filteredSectionEvents)
				}
			})
		default:
			viewModel.EventConferenceDays.value.forEach({ (sectionEntity) in
				let filteredSectionEvents = sectionEntity.Events.filter({ $0.Title.contains(searchText) })
				if filteredSectionEvents.count > 0 {
					searchResultSections.append(sectionEntity)
					searchResults.append(filteredSectionEvents)
				}
			})
		}

		filteredSections = searchResultSections
		filteredEvents = searchResults
		tableView.reloadData()
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

		let viewController: UIViewController
		switch data {
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
		disposable.dispose()
	}
}
