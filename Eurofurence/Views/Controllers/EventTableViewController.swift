//
//  EventTableViewController.swift
//  Eurofurence
//
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import UIKit
import Changeset
import ReactiveSwift

class EventTableViewController: UITableViewController, UISearchResultsUpdating, UISearchBarDelegate {
    let searchController = UISearchController(searchResultsController: nil)
    var filteredEvents: [Event] = []
    var eventByType = ""
    var eventTypeKey = ""

	let viewModel: EventsViewModel = try! ViewModelResolver.container.resolve()
	private var disposable = CompositeDisposable()

    override func viewDidLoad() {
        super.viewDidLoad()

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

    func createCellCustom(_ frame: CGRect) -> UIView {
        let whiteRoundedCornerView = UIView(frame: frame)
        whiteRoundedCornerView.backgroundColor = UIColor(red: 35/255.0, green: 36/255.0, blue: 38/255.0, alpha: 1.0)
        whiteRoundedCornerView.layer.masksToBounds = false
        return whiteRoundedCornerView
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath) as! EventCell
        let event: Event?
        if searchController.isActive && searchController.searchBar.text != "" {
            event = self.filteredEvents[(indexPath as NSIndexPath).row]
        } else {
            cell.eventDayLabel.isHidden = true

            if cell.eventDayLabelHeightConstraint != nil {
                cell.eventDayLabelHeightConstraint!.isActive = true
            } else {
                cell.eventDayLabelHeightConstraint = NSLayoutConstraint(item: cell.eventDayLabel, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 0)
                cell.addConstraint(cell.eventDayLabelHeightConstraint!)
            }

            switch self.searchController.searchBar.selectedScopeButtonIndex {
            case 1:
                event = viewModel.EventConferenceRooms.value[indexPath.section].Events[indexPath.row]
            case 2:
                event = viewModel.EventConferenceTracks.value[indexPath.section].Events[indexPath.row]
            default:
                event = viewModel.EventConferenceDays.value[indexPath.section].Events[indexPath.row]
            }

        }
		cell.event = event

        return cell
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

        return headerCell
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
    }

    // MARK: - UISearchBar Delegate
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        self.tableView.reloadData()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "EventTableViewSegue" {
            if let destinationVC = segue.destination as? EventViewController {
                let indexPath = self.tableView.indexPathForSelectedRow!
                if searchController.isActive && searchController.searchBar.text != "" {
                    destinationVC.event = self.filteredEvents[(indexPath as NSIndexPath).row]
                } else {
                    switch self.searchController.searchBar.selectedScopeButtonIndex {
                    case 0:
                        destinationVC.event = viewModel.EventConferenceDays.value[indexPath.section].Events[indexPath.row]
                    case 1:
                        destinationVC.event = viewModel.EventConferenceRooms.value[indexPath.section].Events[indexPath.row]
                    case 2:
                        destinationVC.event = viewModel.EventConferenceTracks.value[indexPath.section].Events[indexPath.row]
					default:
						destinationVC.event = viewModel.EventConferenceDays.value[indexPath.section].Events[indexPath.row]
                    }
                }

            }
        }
    }

	deinit {
		disposable.dispose()
	}
}
