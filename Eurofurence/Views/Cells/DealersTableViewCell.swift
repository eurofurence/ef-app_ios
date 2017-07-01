//
//  DealersTableViewCell.swift
//  Eurofurence
//
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import UIKit

class DealersTableViewCell: UITableViewCell {
    @IBOutlet weak var subnameDealerLabel: UILabel!
    @IBOutlet weak var artistDealerImage: UIImageView!
    @IBOutlet weak var displayNameDealerLabel: UILabel!
	@IBOutlet weak var shortDescriptionDealerLabel: UILabel!
	
	weak private var _dealer: Dealer?
	
	var dealer: Dealer? {
		get {
			return _dealer
		}
		set(dealer) {
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
			/*if let artistThumbnailImage = dealer.ArtistThumbnailImage {
			let optionalDealerImage = ImageManager.sharedInstance.retrieveFromCache(artistThumbnailImage.Id, imagePlaceholder: UIImage(named: "defaultAvatar"))
			if let dealerImage = optionalDealerImage {
			cell.artistDealerImage.image = dealerImage.af_imageRoundedIntoCircle().af_imageRoundedIntoCircle();
			}
			
			}
			else {*/
				artistDealerImage.image = UIImage(named: "defaultAvatar")!.af_imageRoundedIntoCircle();
			//}
		}
	}
}
