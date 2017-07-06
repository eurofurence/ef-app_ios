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
	
	private var disposable: Disposable? = nil

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

			self.backgroundColor =  UIColor(red: 35/255.0, green: 36/255.0, blue: 38/255.0, alpha: 1.0)
			shortDescriptionDealerLabel.text = dealer?.ShortDescription

			// TODO: Implement image caching
			artistDealerImage.image = UIImage(named: "defaultAvatar")!.af_imageRoundedIntoCircle()
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
