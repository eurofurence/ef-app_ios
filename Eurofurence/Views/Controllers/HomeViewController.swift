//
//  HomeViewController.swift
//  Eurofurence
//
//  Created by Dominik Schöner on 2017-05-06.
//  Copyright © 2017 Dominik Schöner. All rights reserved.
//

import Result
import ReactiveCocoa
import ReactiveSwift
import UIKit
import Changeset

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

	@IBOutlet weak var progressBar: UIProgressView?
	@IBOutlet weak var eventsTable: UITableView?

	static private let eventDateFormatter: DateFormatter = DateFormatter()

	private var announcementsViewModel: AnnouncementsViewModel = try! ViewModelResolver.container.resolve()
	private var currentEventsViewModel: CurrentEventsViewModel = try! ViewModelResolver.container.resolve()

    override func viewDidLoad() {
		super.viewDidLoad()

	    HomeViewController.eventDateFormatter.dateFormat = "hh:mm"
		
		progressBar?.setProgress(0.0, animated: false)

	    eventsTable?.dataSource = self
	    eventsTable?.delegate = self

	    currentEventsViewModel.UpcomingEventsEdits.producer.startWithValues({ eventEdits in
		    self.eventsTable?.update(with: eventEdits)
		    print("Update! \(eventEdits.count)")
	    })
		
		let contextManager = try! ContextResolver.container.resolve(tag: Environment.Production) as ContextManager
		let dataContext = try! ContextResolver.container.resolve() as IDataContext
		
		dataContext.loadFromStore().start(on: QueueScheduler.concurrent).start({ event in
			switch event {
			case let .value(value):
				DispatchQueue.main.async {
					self.progressBar?.setProgress(Float(value.fractionCompleted), animated: true)
				}
				print("Loading completed by \(value.fractionCompleted)")
			case let .failed(error):
				print("Failed: \(error)")
				
				contextManager.syncWithApi?.apply(1234).start({ event in
					guard let value = event.value else {
						print("Error: \(String(describing: event.error))")
						return
					}
					print("Sync completed by \(value.fractionCompleted)")
				})
			case .completed:
				DispatchQueue.main.async {
					self.progressBar?.setProgress(0.0, animated: false)
				}
				print("Completed")
			case .interrupted:
				print("Interrupted")
			}
		})
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

	func tableView(_ tableView: UITableView, numberOfRowsInSection: Int) -> Int {
		if tableView == self.eventsTable {
			return currentEventsViewModel.UpcomingEvents.value.count
		}

		return 0
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

		var cell:UITableViewCell?

		if tableView == self.eventsTable {
			let eventCell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath) as! EventCell
			let event = currentEventsViewModel.UpcomingEvents.value[indexPath.row] as Event
			eventCell.startTimeLabel.text = HomeViewController.eventDateFormatter.string(from: event.StartDateTimeUtc)
			eventCell.endTimeLabel.text = HomeViewController.eventDateFormatter.string(from: event.EndDateTimeUtc)
			eventCell.titleLabel.text = event.Title
			eventCell.subTitleLabel.text = event.SubTitle

			cell = eventCell
		}

		return cell!
	}


	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		print("did select:      \(indexPath.row)  ")
	}
}

