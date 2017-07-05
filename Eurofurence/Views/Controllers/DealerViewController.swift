//
//  DealerViewController.swift
//  Eurofurence
//
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class DealerViewController: UIViewController {
    /// Higher numbers zoom out farther
    static var MAP_SEGMENT_ZOOM = CGFloat(8.0)

	weak var dealer: Dealer?
    @IBOutlet weak var artistImageView: UIImageView!
    @IBOutlet weak var displayNameLabel: UILabel!
    @IBOutlet weak var attendeeNicknameLabel: UILabel!
    @IBOutlet weak var artistShortDescriptionLabel: UILabel!
    @IBOutlet weak var aboutArtistLabel: UILabel!
    @IBOutlet weak var artPreviewImageView: UIView!
    @IBOutlet weak var artPreviewImage: UIImageView!
    @IBOutlet weak var artPreviewCaption: UILabel!
    @IBOutlet weak var aboutArtTitleLabel: UILabel!
    @IBOutlet weak var aboutArtLabel: UILabel!
    @IBOutlet weak var aboutArtLabelTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var dealersDenLabelTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var dealersDenMapImageView: UIImageView!
    var singleTap: UITapGestureRecognizer!

    func canRotate() -> Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        // add jump to map on single tap on map segment
        singleTap = UITapGestureRecognizer(target: self, action: #selector(DealerViewController.showOnMap(_:)))
        dealersDenMapImageView!.addGestureRecognizer(singleTap!)
        dealersDenMapImageView!.isUserInteractionEnabled = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func willMove(toParentViewController parent: UIViewController?) {
        super.willMove(toParentViewController: parent)
        if parent == nil {
            self.tabBarController?.tabBar.isHidden = false
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
        let newlineChars = CharacterSet.newlines

		// TODO: Implement image caching
        /*if let  artistImageId = dealer.ArtistImageId {
            artistImage.image = ImageManager.sharedInstance.retrieveFromCache(artistImageId, imagePlaceholder: UIImage(named: "defaultAvatarBig"))
        } else {*/
            artistImageView.image = UIImage(named: "defaultAvatarBig")!
        //}

		if let _ = dealer?.DisplayName, !dealer!.DisplayName.isEmpty {
			displayNameLabel.text = dealer?.DisplayName
			attendeeNicknameLabel.text = dealer?.AttendeeNickname
		} else {
			displayNameLabel.text = dealer?.AttendeeNickname
			attendeeNicknameLabel.text = nil
		}

        artistShortDescriptionLabel.text = dealer?.ShortDescription.utf16.split { newlineChars.contains(UnicodeScalar($0)!) }.flatMap(String.init).joined(separator: "\n")
        artistShortDescriptionLabel.sizeToFit()

        let aboutArtistText = dealer?.AboutTheArtistText.utf16.split { newlineChars.contains(UnicodeScalar($0)!) }.flatMap(String.init).joined(separator: "\n")
        if (aboutArtistText == "") {
			// TODO: Externalise strings for i18n
            aboutArtistLabel.text = "The artist did not provide any information about themselves to be shown here."
        } else {
            aboutArtistLabel.text = aboutArtistText
        }
        aboutArtistLabel.sizeToFit()

		// TODO: Implement image caching
        /*if let artPreviewImageId = self.dealer.ArtPreviewImageId, let artPreviewImage = ImageManager.sharedInstance.retrieveFromCache(artPreviewImageId) {
            self.artPreviewImage.image = artPreviewImage
            self.artPreviewImage.sizeToFit()
            
            let artPreviewCaption = self.dealer.ArtPreviewCaption!.utf16.split { newlineChars.contains(UnicodeScalar($0)!) }.flatMap(String.init)
            let finalStringArtPreviewCaption = artPreviewCaption.joined(separator: "\n");
            if (finalStringArtPreviewCaption == "") {
                self.artPreviewCaption.text = ""
            }
            else {
                self.artPreviewCaption.text = finalStringArtPreviewCaption;
            }
            self.artPreviewCaption.sizeToFit();
        } else {*/
            // if no image has been provided, hide the image section along with the caption
            if(self.artPreviewImage != nil) {
                artPreviewImage.image = nil
            }
            for subview in artPreviewImageView.subviews {
                subview.removeFromSuperview()
            }
            let heightConstraint = NSLayoutConstraint(item: artPreviewImageView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 0)
            artPreviewImageView.addConstraint(heightConstraint)
        //}

        let aboutArtText = dealer?.AboutTheArtText.utf16.split { newlineChars.contains(UnicodeScalar($0)!) }.flatMap(String.init).joined(separator: "\n")
        if let aboutArtText = aboutArtText, !aboutArtText.isEmpty {
			aboutArtLabel.text = aboutArtText
			aboutArtLabel.sizeToFit()
        } else {
			aboutArtLabel.text = nil

			// if neither text nor image have been provided, hide the entire about art section
			if artPreviewImage == nil || artPreviewImage.image == nil {
				aboutArtTitleLabel.text = nil
				aboutArtLabelTopConstraint.constant = 0
				dealersDenLabelTopConstraint.constant = 0
			}
        }

		// TODO: Implement image caching
        /*if let mapEntry = MapEntry.getByTargetId(self.dealer.Id), let map = Map.getById(mapEntry.MapId), let mapImage = ImageManager.sharedInstance.retrieveFromCache(map.ImageId!), let mapEntryLocation = mapEntry.getAbsoluteLocationForImage(mapImage), let tapRadius = mapEntry.getAbsoluteTapRadiusForImage(mapImage) {
            
            let ratio = self.dealersDenMapImage.bounds.width / self.dealersDenMapImage.bounds.height
            
            let segmentHeight = tapRadius * DealerViewController.MAP_SEGMENT_ZOOM
            let segmentWidth = segmentHeight * ratio
            
            let offsetX = min(max(0.0, mapEntryLocation.x - segmentWidth / 2.0), mapImage.size.width - segmentWidth)
            let offsetY = min(max(0.0, mapEntryLocation.y - segmentHeight / 2.0), mapImage.size.height - segmentHeight)
            
            if let croppedMap = (mapImage.cgImage)?.cropping(to: CGRect(x: offsetX, y: offsetY, width: segmentWidth, height: segmentHeight)) {
            
                // Initialise the context
                let size = CGSize(width: segmentWidth, height: segmentHeight)
                let opaque = true
                let scale: CGFloat = 0
                UIGraphicsBeginImageContextWithOptions(size, opaque, scale)
                let context = UIGraphicsGetCurrentContext()
                
                // Draw the map segment
                UIImage(cgImage: croppedMap).draw(in: CGRect(origin: CGPoint.zero, size: size))
                
                context?.setStrokeColor(UIColor.red.cgColor)
                context?.setLineWidth(2.0)
                
                let highlightRect = CGRect(x: mapEntryLocation.x - offsetX - tapRadius, y: mapEntryLocation.y - offsetY - tapRadius, width: tapRadius * 2, height: tapRadius * 2)
                context?.strokeEllipse(in: highlightRect)
                
                // Drawing complete, retrieve the finished image and cleanup
                self.dealersDenMapImage.image = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
            }
        }*/
    }

    func showOnMap(_ tapGesture: UITapGestureRecognizer) {
        if let mapEntry = dealer?.MapEntry {
            self.performSegue(withIdentifier: "DealerDetailViewToMapSegue", sender: mapEntry)
        }
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
        if segue.identifier == "DealerDetailViewToMapSegue" {
            if let destinationVC = segue.destination as? MapViewController, let mapEntry = sender as? MapEntry {
                destinationVC.currentMapEntry = mapEntry
                destinationVC.currentMapEntryRadiusMultiplier = 10.0
                self.tabBarController?.tabBar.isHidden = false
            }
        }
    }

}
