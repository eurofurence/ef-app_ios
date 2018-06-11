//
//  EventViewController.swift
//  Eurofurence
//
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import UIKit
import ReactiveSwift

class EventViewController: UIViewController {
	@IBOutlet weak var eventDescTextView: UITextView!
	@IBOutlet weak var eventFavoriteButton: UIButton!
	@IBOutlet weak var eventHostLabel: UILabel!
	@IBOutlet weak var eventImageSpacerView: UIView!
	@IBOutlet weak var eventImageView: UIImageView!
	@IBOutlet weak var eventImageViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var eventLocationLabel: UILabel!
    @IBOutlet weak var eventLocationIconLabel: UILabel!
    @IBOutlet weak var eventSubTitleLabel: UILabel!
	@IBOutlet weak var eventStartTimeLabel: UILabel!
	@IBOutlet weak var eventTitleLabel: UILabel!
	@IBOutlet weak var eventTrackLabel: UILabel!
	var eventLocationLabelDefaultColor: UIColor = UIColor.white
    var singleTapLocation: UITapGestureRecognizer!
    var singleTapLocationIcon: UITapGestureRecognizer!

	let imageService: ImageServiceProtocol = try! ServiceResolver.container.resolve()

	weak var event: Event?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        eventLocationLabelDefaultColor = eventLocationLabel.textColor
		view.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "Background Tile"))
		eventDescTextView.textContainer.lineFragmentPadding = 0.0

        singleTapLocation = UITapGestureRecognizer(target: self, action: #selector(EventViewController.showOnMap(_:)))
        eventLocationLabel!.addGestureRecognizer(singleTapLocation!)
        eventLocationLabel!.isUserInteractionEnabled = true

        singleTapLocationIcon = UITapGestureRecognizer(target: self, action: #selector(EventViewController.showOnMap(_:)))
        eventLocationIconLabel!.addGestureRecognizer(singleTapLocationIcon!)
        eventLocationIconLabel!.isUserInteractionEnabled = true
    }

    override func viewWillAppear(_ animated: Bool) {
		guard let event = event else {
			return
		}

		if let _ = event.ConferenceRoom?.MapEntry {
			eventLocationLabel.textColor = eventLocationLabel.tintColor
		} else {
			eventLocationLabel.textColor = eventLocationLabelDefaultColor
		}

		let weekday = DateFormatters.weekdayLong.string(from: event.StartDateTimeUtc)
		let startTime = DateFormatters.hourMinute.string(from: event.StartDateTimeUtc)
		let endTime = DateFormatters.hourMinute.string(from: event.EndDateTimeUtc)
		self.eventStartTimeLabel.text = "\(weekday), \(startTime) to \(endTime)"
        eventStartTimeLabel.accessibilityLabel = "Takes place on \(weekday) from \(startTime) to \(endTime)"
		self.eventLocationLabel.text = event.ConferenceRoom?.Name

        if let roomName = event.ConferenceRoom?.Name {
            eventLocationLabel.accessibilityLabel = "Takes place in \(roomName)"
        } else {
            eventLocationLabel.accessibilityLabel = event.ConferenceRoom?.Name
        }

		self.eventTrackLabel.text = event.ConferenceTrack?.Name

        if let track = event.ConferenceTrack?.Name {
            eventTrackLabel.accessibilityLabel = "Part of the \(track) track"
        } else {
            eventTrackLabel.accessibilityLabel = event.ConferenceTrack?.Name
        }

		self.eventHostLabel.text = event.PanelHosts
        eventHostLabel.accessibilityLabel = "Hosted by \(event.PanelHosts)"

		if let eventFavorite = event.EventFavorite {
			self.eventFavoriteButton.reactive.isSelected <~ eventFavorite.IsFavorite
		} else {
			self.eventFavoriteButton.isSelected = false
		}

		self.title = event.ConferenceDay?.Name
        self.eventTitleLabel.text = event.Title
        self.eventSubTitleLabel.text = event.SubTitle
        self.eventDescTextView.text = event.Description
        self.eventDescTextView.scrollsToTop = true
        self.eventDescTextView.scrollRangeToVisible(NSRange(location: 0, length: 1))

		var eventImage: Image? = event.PosterImage
		if eventImage == nil {
			eventImage = event.BannerImage
		}

		eventImageView.image = #imageLiteral(resourceName: "ef")
		if let eventImage = eventImage {
			eventImageSpacerView.isHidden = false
			eventImageView.isHidden = false
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
		} else {
			eventImageSpacerView.isHidden = true
			eventImageView.isHidden = true
		}

        updateEventFavoriteButtonAccessibilityHint()
    }

	private func resizeImageView(for image: UIImage) {
		let ratio = image.size.width / image.size.height
		if let view = eventImageView.superview {
			let newHeight = min(view.frame.width, image.size.width) / ratio
			eventImageView.frame.size = CGSize(width: view.frame.width, height: newHeight)
			eventImageViewHeightConstraint.constant = newHeight
		}
	}

	@IBAction func toggleEventFavorite(_ sender: UIButton) {
		if let eventFavorite = event?.EventFavorite {
			eventFavorite.IsFavorite.swap(!sender.isSelected)
            updateEventFavoriteButtonAccessibilityHint()
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

	@objc func showOnMap(_ tapGesture: UITapGestureRecognizer) {
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
                destinationVC.currentMapEntryRadiusMultiplier = 10.0
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

    private func updateEventFavoriteButtonAccessibilityHint() {
        let hint: String
        if let favorite = event?.EventFavorite, favorite.IsFavorite.value {
            hint = "Double tap to remove this event from your favorites"
        } else {
            hint = "Double tap to add this event to your favorites"
        }

        eventFavoriteButton.accessibilityHint = hint
    }

}
