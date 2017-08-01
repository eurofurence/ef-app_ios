//
//  DealerViewController.swift
//  Eurofurence
//
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import UIKit
import ReactiveSwift

class DealerViewController: UIViewController {
    /// Higher numbers zoom out farther
    static var MAP_SEGMENT_ZOOM = CGFloat(8.0)

	weak var dealer: Dealer?
    @IBOutlet weak var artistImageView: UIImageView!
    @IBOutlet weak var displayNameLabel: UILabel!
    @IBOutlet weak var attendeeNicknameLabel: UILabel!
    @IBOutlet weak var artistShortDescriptionLabel: UILabel!
    @IBOutlet weak var aboutArtistLabel: UILabel!
	@IBOutlet weak var aboutArtTitleLabel: UILabel!
    @IBOutlet weak var artPreviewImageView: UIImageView!
    @IBOutlet weak var artPreviewCaption: UILabel!
	@IBOutlet weak var aboutArtLabel: UILabel!
	@IBOutlet weak var dealersDenMapTitleLabel: UILabel!
	@IBOutlet weak var dealersDenMapImageView: UIImageView!
    var singleTap: UITapGestureRecognizer!

	private var disposables = CompositeDisposable()
	private let imageService: ImageServiceProtocol = try! ServiceResolver.container.resolve()

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

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)

		disposables.dispose()
	}

    override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		if !disposables.isDisposed {
			disposables.dispose()
		}
		disposables = CompositeDisposable()

        let newlineChars = CharacterSet.newlines

		artistImageView.image = #imageLiteral(resourceName: "defaultAvatarBig")
		if let artistImage = dealer?.ArtistImage {
			disposables += imageService.retrieve(for: artistImage).startWithResult({ [weak self] result in
				guard let strongSelf = self else { return }
				switch result {
				case let .success(value):
					DispatchQueue.main.async {
						strongSelf.artistImageView.image = value
					}
				case .failure:
					break
				}
			})
		}

		if let _ = dealer?.DisplayName, !dealer!.DisplayName.isEmpty {
			displayNameLabel.text = dealer?.DisplayName
			attendeeNicknameLabel.text = dealer?.AttendeeNickname
		} else {
			displayNameLabel.text = dealer?.AttendeeNickname
			attendeeNicknameLabel.text = nil
			attendeeNicknameLabel.isHidden = true
		}

        artistShortDescriptionLabel.text = dealer?.ShortDescription.utf16.split { newlineChars.contains(UnicodeScalar($0)!) }.flatMap(String.init).joined(separator: "\n")
        artistShortDescriptionLabel.sizeToFit()

        let aboutArtistText = dealer?.AboutTheArtistText.utf16.split { newlineChars.contains(UnicodeScalar($0)!) }.flatMap(String.init).joined(separator: "\n")
        if let aboutArtistText = aboutArtistText, !aboutArtistText.isEmpty {
			aboutArtistLabel.text = aboutArtistText
        } else {
			// TODO: Externalise strings for i18n
			aboutArtistLabel.text = "The artist did not provide any information about themselves to be shown here."
        }
        aboutArtistLabel.sizeToFit()

		if let artPreviewImage = dealer?.ArtPreviewImage {
			artPreviewImageView.image = #imageLiteral(resourceName: "ef")
			artPreviewImageView.sizeToFit()
			artPreviewCaption.text = nil
			disposables += imageService.retrieve(for: artPreviewImage).startWithResult({ [weak self] result in
				guard let strongSelf = self else { return }
				switch result {
				case let .success(value):
					DispatchQueue.main.async {
						strongSelf.artPreviewImageView.image = value
						strongSelf.artPreviewImageView.sizeToFit()

						if let artPreviewCaption = strongSelf.dealer?.ArtPreviewCaption {
							strongSelf.artPreviewCaption.text = artPreviewCaption.utf16.split { newlineChars.contains(UnicodeScalar($0)!) }.flatMap(String.init).joined(separator: "\n")
						}
						strongSelf.artPreviewCaption.sizeToFit()
					}
				case .failure:
					break
				}
			})
		} else {
			artPreviewImageView.isHidden = true
			artPreviewCaption.isHidden = true
		}

        let aboutArtText = dealer?.AboutTheArtText.utf16.split { newlineChars.contains(UnicodeScalar($0)!) }.flatMap(String.init).joined(separator: "\n")
        if let aboutArtText = aboutArtText, !aboutArtText.isEmpty {
			aboutArtLabel.text = aboutArtText
			aboutArtLabel.sizeToFit()
        } else {
			aboutArtLabel.isHidden = true

			// if neither text nor image have been provided, hide the entire about art section
			if artPreviewImageView.isHidden {
				aboutArtTitleLabel.isHidden = true
			}
        }

        if let mapEntry = dealer?.MapEntry, let map = mapEntry.Map, let mapImage = map.Image {

			disposables += imageService.retrieve(for: mapImage).startWithResult({ [weak self] result in
				guard let strongSelf = self else { return }
				switch result {
				case let .success(value):
					let ratio = strongSelf.dealersDenMapImageView.bounds.width / strongSelf.dealersDenMapImageView.bounds.height

					let segmentHeight = mapEntry.CGTapRadius * DealerViewController.MAP_SEGMENT_ZOOM
					let segmentWidth = segmentHeight * ratio

					let offsetX = min(max(0.0, mapEntry.CGX - segmentWidth / 2.0), value.size.width - segmentWidth)
					let offsetY = min(max(0.0, mapEntry.CGY - segmentHeight / 2.0), value.size.height - segmentHeight)

					if let croppedMap = (value.cgImage)?.cropping(to: CGRect(x: offsetX, y: offsetY, width: segmentWidth, height: segmentHeight)) {

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

						let highlightRect = CGRect(x: mapEntry.CGX - offsetX - mapEntry.CGTapRadius, y: mapEntry.CGY - offsetY - mapEntry.CGTapRadius, width: mapEntry.CGTapRadius * 2, height: mapEntry.CGTapRadius * 2)
						context?.strokeEllipse(in: highlightRect)

						// Drawing complete, retrieve the finished image and cleanup
						strongSelf.dealersDenMapImageView.image = UIGraphicsGetImageFromCurrentImageContext()
						UIGraphicsEndImageContext()
					}
				case .failure:
					break
				}
			})
        }
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
                destinationVC.mapEntry = mapEntry
                destinationVC.currentMapEntryRadiusMultiplier = 10.0
            }
        }
    }

}
