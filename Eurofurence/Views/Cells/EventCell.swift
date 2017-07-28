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

                accessibilityLabel = "\(event.Title), \(event.SubTitle). Starts at \(startTimeText), ends at \(endTimeText)"
			} else {
				disposable.dispose()
				startTimeLabel.text = nil
				endTimeLabel.text = nil
			}
			titleLabel.text = event?.Title
			subTitleLabel.text = event?.SubTitle
		}
	}

	func toggleFavorite(button: UIButton) {
		button.isSelected = !button.isSelected
		if let eventFavorite = event?.EventFavorite {
			eventFavorite.IsFavorite.swap(button.isSelected)
		}
	}
}
