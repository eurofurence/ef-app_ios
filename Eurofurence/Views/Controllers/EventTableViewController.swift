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
    var filteredEvents: [Event] = []
    var eventByType = ""
    var eventTypeKey = ""

	let viewModel: EventsViewModel = try! ViewModelResolver.container.resolve()
	private var disposable = CompositeDisposable()

    override func viewDidLoad() {
        super.viewDidLoad()

		if traitCollection.forceTouchCapability == .available {
			registerForPreviewing(with: self, sourceView: view)
		}

		// TODO: Make search bar comply to reactive paradigm
        searchController.searchBar.showsScopeBar = false
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        searchController.searchBar.tintColor = UIColor.white
		searchController.searchBar.scopeButtonTitles = ["Day", "Room", "Track"]
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120.0
        tableView.sectionHeaderHeight = UITableViewAutomaticDimension
        tableView.estimatedSectionHeaderHeight = 100.0
        tableView.backgroundColor =  UIColor(red: 35/255.0, green: 36/255.0, blue: 38/255.0, alpha: 1.0)
        refreshControl?.addTarget(self, action: #selector(EventTableViewController.refresh(_:)), for: UIControlEvents.valueChanged)
        refreshControl?.backgroundColor = UIColor.clear

		tableView.register(UINib(nibName: "EventCell", bundle: nil), forCellReuseIdentifier: "EventCell")

        disposable += viewModel.Events.signal.observeResult({[unowned self] _ in
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })

        guard let refreshControl = refreshControl else { return }

        let refreshControlVisibilityDelegate = RefreshControlDataStoreDelegate(refreshControl: refreshControl)
        DataStoreRefreshController.shared.add(refreshControlVisibilityDelegate)
	}

	// TODO: Pull into super class for all refreshable ViewControllers
	/// Initiates sync with API via refreshControl
	func refresh(_ sender: AnyObject) {
		DataStoreRefreshController.shared.refreshStore()
	}

    override func viewWillAppear(_ animated: Bool) {
        switch self.eventByType {
        case "Room":
            self.searchController.searchBar.selectedScopeButtonIndex = 1
        case "Track":
            self.searchController.searchBar.selectedScopeButtonIndex = 2
        default: // "Day"
			self.searchController.searchBar.selectedScopeButtonIndex = 0
        }

		// TODO: Observe viewModel.Events for changes while view is displayed
		// TODO: Update view by days based on TimeService ticks?
    }

	override func viewWillDisappear(_ animated: Bool) {
		refreshControl?.endRefreshing()
	}

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        var eventNumber = 1
        if searchController.isActive && searchController.searchBar.text != "" {
            return eventNumber
        }

        switch self.searchController.searchBar.selectedScopeButtonIndex {
        case 1:
            eventNumber = viewModel.EventConferenceRooms.value.count
        case 2:
            eventNumber = viewModel.EventConferenceTracks.value.count
        default:
			eventNumber = viewModel.EventConferenceDays.value.count
        }
        return eventNumber
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return self.filteredEvents.count
        }
        var sectionRowCount = 0
        switch self.searchController.searchBar.selectedScopeButtonIndex {
        case 1:
            sectionRowCount = viewModel.EventConferenceRooms.value[section].Events.count
        case 2:
            sectionRowCount = viewModel.EventConferenceTracks.value[section].Events.count
        default:
			sectionRowCount = viewModel.EventConferenceDays.value[section].Events.count
        }
        return sectionRowCount

    }

    private func addBorderUtility(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat, color: UIColor) -> CALayer {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: x, y: y, width: width, height: height)
        return border
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath) as? EventCell,
			let event = getData(for: indexPath) as? Event else { return UITableViewCell() }
		cell.event = event

        return cell
    }

	func getData(for indexPath: IndexPath) -> EntityBase? {
		if searchController.isActive && searchController.searchBar.text != "" {
			return self.filteredEvents[(indexPath as NSIndexPath).row]
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

	func updateSearchResults(for searchController: UISearchController) {
        let searchResults = viewModel.Events.value.filter({$0.Title.contains(searchController.searchBar.text!)})
		filteredEvents = searchResults
		tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView(frame: .zero)
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let  headerCell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell") as! EventHeaderCellTableViewCell
        if searchController.isActive && searchController.searchBar.text != "" {
			// TODO: Externalise strings for i18n
            headerCell.headerCellLabel.text = "Results for : " + searchController.searchBar.text!
            return headerCell
        }

        switch self.searchController.searchBar.selectedScopeButtonIndex {
        case 1:
            headerCell.headerCellLabel.text = viewModel.EventConferenceRooms.value[section].Name
        case 2:
            headerCell.headerCellLabel.text = viewModel.EventConferenceTracks.value[section].Name
        default:
            headerCell.headerCellLabel.text = viewModel.EventConferenceDays.value[section].Name + "\n" + DateFormatters.dayMonthLong.string(from: viewModel.EventConferenceDays.value[section].Date)
        }

        return headerCell.contentView
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
	}

    // MARK: - UISearchBar Delegate
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        self.tableView.reloadData()
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
			let data = getData(for: indexPath) else { return nil }

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
