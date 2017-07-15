//
//  EventViewController.swift
//  Eurofurence
//
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import UIKit

class EventViewController: UIViewController {
    @IBOutlet weak var eventTitleLabel: UILabel!
    @IBOutlet weak var eventLocationLabel: UILabel!
    @IBOutlet weak var eventLocationIconImageView: UIImageView!
    @IBOutlet weak var eventSubTitleLabel: UILabel!
    @IBOutlet weak var eventStartTimeLabel: UILabel!
    @IBOutlet weak var eventDurationLabel: UILabel!
    @IBOutlet weak var eventHostLabel: UILabel!
    @IBOutlet weak var eventDescTextView: UITextView!
    @IBOutlet weak var eventImageHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var eventImageView: UIImageView!
    var eventImageDefaultHeight = CGFloat(0.0)
    var singleTapLocation: UITapGestureRecognizer!
    var singleTapLocationIcon: UITapGestureRecognizer!

	let imageService: ImageServiceProtocol = try! ServiceResolver.container.resolve()

	weak var event: Event?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        eventDescTextView.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)
        eventImageDefaultHeight = eventImageHeightConstraint.constant

        singleTapLocation = UITapGestureRecognizer(target: self, action: #selector(EventViewController.showOnMap(_:)))
        eventLocationLabel!.addGestureRecognizer(singleTapLocation!)
        eventLocationLabel!.isUserInteractionEnabled = true

        singleTapLocationIcon = UITapGestureRecognizer(target: self, action: #selector(EventViewController.showOnMap(_:)))
        eventLocationIconImageView!.addGestureRecognizer(singleTapLocationIcon!)
        eventLocationIconImageView!.isUserInteractionEnabled = true
    }

    override func viewWillAppear(_ animated: Bool) {
		guard let event = event else {
			return
		}

        if let _ = event.ConferenceRoom {
            eventLocationLabel.textColor = eventLocationLabel.tintColor
        }

        self.eventLocationLabel.text = event.ConferenceRoom?.Name
        self.eventStartTimeLabel.text = DateFormatters.hourMinute.string(from: event.StartDateTimeUtc)

		eventDurationLabel.text = event.Duration.dhmString
		if let eventDurationLabelText = eventDurationLabel.text, eventDurationLabelText.isEmpty {
			eventDurationLabel.text = "n/a"
		}

		self.title = event.ConferenceDay?.Name
        self.eventHostLabel.text = event.PanelHosts
        self.eventTitleLabel.text = event.Title
        self.eventSubTitleLabel.text = event.SubTitle
        self.eventDescTextView.text = event.Description
        self.eventDescTextView.scrollsToTop = true
        self.eventDescTextView.scrollRangeToVisible(NSRange(location: 0, length: 1))

		var eventImage: Image? = event.PosterImage
		if eventImage == nil {
			eventImage = event.BannerImage
		}

		if let eventImage = eventImage {
			imageService.retrieve(for: eventImage).startWithResult({ [unowned self] (result) in
				switch result {
				case let .success(image):
					DispatchQueue.main.async {
						self.eventImageView.image = image
						self.resizeImageView(for: image)
					}
				case .failure:
					break
				}
			})
		}
		eventImageView.image = nil
		eventImageHeightConstraint.constant = CGFloat(0.0)
    }

	private func resizeImageView(for image: UIImage) {
		let ratio = image.size.width / image.size.height
		if let view = eventImageView.superview {
			let newHeight = view.frame.width / ratio
			eventImageView.frame.size = CGSize(width: view.frame.width, height: newHeight)
			eventImageHeightConstraint.constant = newHeight
			eventImageView.sizeToFit()
		}
	}

    @IBAction func exportAsEvent(_ sender: AnyObject) {
		guard let event = event else {
			return
		}
		// TODO: externalise strings for i18n
        let alert = UIAlertController(title: "Export event", message: "Export the event to the calendar?", preferredStyle: UIAlertControllerStyle.actionSheet)
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.cancel, handler: nil))
		alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: {
			_ in CalendarAccess.instance.insert(event: event)
		}))

        alert.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem

        self.present(alert, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.eventDescTextView.setContentOffset(CGPoint.zero, animated: false)
	}

	override func viewWillLayoutSubviews() {
		super.viewWillLayoutSubviews()
		if let image = eventImageView.image {
			self.resizeImageView(for: image)
		}
	}

	func showOnMap(_ tapGesture: UITapGestureRecognizer) {
		guard let event = event, let mapEntry = event.ConferenceRoom?.MapEntry else {
			return
		}
		self.performSegue(withIdentifier: "EventDetailViewToMapSegue", sender: mapEntry)
    }

    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EventDetailViewToMapSegue" {
            if let destinationVC = segue.destination as? MapViewController, let mapEntry = sender as? MapEntry {
                destinationVC.mapEntry = mapEntry
                destinationVC.currentMapEntryRadiusMultiplier = 30.0
            }
        }
    }

	// MARK: - Previewing
	lazy var previewActions: [UIPreviewActionItem] = {
		let favoriteActionTitle = self.event?.EventFavorite?.IsFavorite.value ?? false ? "Remove Favorite" : "Add Favorite"
		let favoriteAction = UIPreviewAction(title: favoriteActionTitle, style: .default) { _, viewController in
			guard let eventViewController = viewController as? EventViewController,
				let event = eventViewController.event, let eventFavorite = event.EventFavorite else { return }
			eventFavorite.IsFavorite.swap(!eventFavorite.IsFavorite.value)
		}
		return [favoriteAction]
	}()

	override var previewActionItems: [UIPreviewActionItem] {
		return previewActions
	}

}
