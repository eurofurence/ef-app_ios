//
//  DealersTableViewCell.swift
//  Eurofurence
//
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import UIKit
import ReactiveSwift
import AlamofireImage

class DealersTableViewCell: UITableViewCell {
    @IBOutlet weak var subnameDealerLabel: UILabel!
    @IBOutlet weak var artistDealerImage: UIImageView!
    @IBOutlet weak var displayNameDealerLabel: UILabel!
	@IBOutlet weak var shortDescriptionDealerLabel: UILabel!

	weak private var _dealer: Dealer?

	private var disposable: Disposable?

	var dealer: Dealer? {
		get {
			return _dealer
		}
		set(dealer) {
			if let disposable = disposable, !disposable.isDisposed {
				disposable.dispose()
			}

			_dealer = dealer

			if let displayName = dealer?.DisplayName, !displayName.isEmpty {
				displayNameDealerLabel.text = displayName
				subnameDealerLabel.text = dealer?.AttendeeNickname
			} else {
				displayNameDealerLabel.text = dealer?.AttendeeNickname
				subnameDealerLabel.text = nil
			}

			shortDescriptionDealerLabel.text = dealer?.ShortDescription

			artistDealerImage.image = #imageLiteral(resourceName: "defaultAvatar").af_imageRoundedIntoCircle()
			do {
				let imageService = try ServiceResolver.container.resolve() as ImageServiceProtocol
				if let artistThumbnailImage = dealer?.ArtistThumbnailImage {
					disposable = imageService.retrieve(for: artistThumbnailImage).startWithResult { [weak self] result in
						guard let strongSelf = self else {
							return
						}
						switch result {
						case let .success(value):
							DispatchQueue.main.async {
								strongSelf.artistDealerImage.image = value.af_imageRoundedIntoCircle()
							}
						case .failure:
							break
						}
					}
				}
			} catch {
			}
		}
	}
}
