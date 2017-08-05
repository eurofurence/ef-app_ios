//
//  EventCell.swift
//  Eurofurence
//
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa

class EventCell: UITableViewCell {

	@IBOutlet weak var bannerImageView: UIImageView!
	@IBOutlet weak var endTimeLabel: UILabel!
	@IBOutlet weak var favoriteLabel: UILabel!
	@IBOutlet weak var iconsLabel: UILabel!
	@IBOutlet weak var startTimeLabel: UILabel!
	@IBOutlet weak var subTitleLabel: UILabel!
	@IBOutlet weak var titleLabel: UILabel!

	let imageService: ImageServiceProtocol = try! ServiceResolver.container.resolve()
	let disposable: SerialDisposable = SerialDisposable()

	weak private var _event: Event?

	var event: Event? {
		get {
			return _event
		}
		set(event) {
			_event = event
			if let event = event {
                let startTimeText = DateFormatters.hourMinute.string(from: event.StartDateTimeUtc)
                let endTimeText = DateFormatters.hourMinute.string(from: event.EndDateTimeUtc)

				startTimeLabel.text = startTimeText
				endTimeLabel.text = endTimeText
				if let eventFavorite = event.EventFavorite {
					disposable.inner = favoriteLabel.reactive.isHidden <~ eventFavorite.IsFavorite.map({ !$0 })
				} else {
					disposable.dispose()
					favoriteLabel.isHidden = true
				}
				if let bannerImage = event.BannerImage {
					imageService.retrieve(for: bannerImage).startWithResult({ [unowned self] (result) in
						switch result {
						case let .success(image):
							DispatchQueue.main.async {
								self.bannerImageView.image = image
							}
							break
						case .failure:
							break
						}
					})
				} else {
					let zeroHeightConstraint = NSLayoutConstraint(item: bannerImageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0, constant: 0)
					zeroHeightConstraint.isActive = true
					bannerImageView.addConstraint(zeroHeightConstraint)
					bannerImageView.updateConstraints()
				}

                var label = "\(event.Title), \(event.SubTitle). Starts at \(startTimeText), ends at \(endTimeText)."
                if let favorite = event.EventFavorite, favorite.IsFavorite.value {
                    label += " Favorite event."
                }

				setupEventIcons()

                accessibilityLabel = label
			} else {
				disposable.dispose()
				startTimeLabel.text = nil
				endTimeLabel.text = nil
				iconsLabel.text = nil
			}
			titleLabel.text = event?.Title
			subTitleLabel.text = event?.SubTitle
		}
	}

	private func setupEventIcons() {
		guard let event = event else { return }

		/*
		+------+------------------+--------------------+
		| UTF8 | Name             | Event Type         |
		+------+------------------+--------------------+
		| f03e | fa-camera        | Art Show           |
		| f07a | fa-shopping-cart | Dealers' Den       |
		| f069 | fa-asterisk      | Stage              |
		| f030 | fa-camera        | Photoshoot         |
		| f219 | fa-diamond       | Supersponsor Event |
		| f000 | fa-bug           | Onkel Kage         |
		| f188 | fa-glass         | Onkel Kage         |
		+------+------------------+--------------------+
		*/

		var iconText = ""
		if let conferenceTrackName = event.ConferenceTrack?.Name {
			switch conferenceTrackName {
			case "Art Show":
				iconText += "\u{f03e}"
			case "Dealers' Den":
				iconText += "\u{f07a}"
			case "Stage":
				iconText += "\u{f069}"
			case "Photoshoot":
				iconText += "\u{f030}"
			case "Supersponsor Event":
				iconText += "\u{f219}"
			default:
				break
			}
		}
		if event.PanelHosts.contains("Onkel Kage") {
			iconText += "\u{f000}\u{f188}"
		}

		iconsLabel.text = iconText
		iconsLabel.isHidden = iconsLabel.text?.isEmpty ?? true
	}

	func toggleFavorite(button: UIButton) {
		button.isSelected = !button.isSelected
		if let eventFavorite = event?.EventFavorite {
			eventFavorite.IsFavorite.swap(button.isSelected)
		}
	}
}
