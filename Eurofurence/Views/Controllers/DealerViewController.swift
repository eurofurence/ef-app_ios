//
//  DealerViewController.swift
//  Eurofurence
//
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import UIKit
import ReactiveSwift
import SafariServices

class DealerViewController: UIViewController {
    /// Higher numbers zoom out farther
    static var MAP_SEGMENT_ZOOM = CGFloat(8.0)
	static let telegramLinkBase = "https://t.me/"
	static let twitterLinkBase = "https://twitter.com/"

	weak var dealer: Dealer?
    @IBOutlet weak var artistImageView: UIImageView!
    @IBOutlet weak var displayNameLabel: UILabel!
    @IBOutlet weak var attendeeNicknameLabel: UILabel!
	@IBOutlet weak var socialButtonsView: UIStackView!
    @IBOutlet weak var artistShortDescriptionLabel: UILabel!
	@IBOutlet weak var aboutArtistLabel: UILabel!
	@IBOutlet weak var aboutArtSpacerView: UIView!
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

		view.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "Background Tile"))
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

		setupArtistImage()

		setupArtistName()

		setupSocialButtons()

        setupShortDescription()

		setupAbout()

		setupArtPreview()

		setupAboutArt()

		setupMapImage()
    }

	private func setupArtistImage() {
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
	}

	private func setupArtistName() {
		if let _ = dealer?.DisplayName, !dealer!.DisplayName.isEmpty {
			displayNameLabel.text = dealer?.DisplayName
			attendeeNicknameLabel.text = dealer?.AttendeeNickname
		} else {
			displayNameLabel.text = dealer?.AttendeeNickname
			attendeeNicknameLabel.text = nil
			attendeeNicknameLabel.isHidden = true
		}
	}

	private func setupSocialButtons() {
		while socialButtonsView.arrangedSubviews.count > 2 {
			let removableButton = socialButtonsView.arrangedSubviews[1]
			socialButtonsView.removeArrangedSubview(removableButton)
			removableButton.removeFromSuperview()
		}
		if (dealer?.Links.count ?? 0) >= 1 {
			createSocialButton(icon: "\u{f0ac}", action: #selector(openExternalLink),
			                   accessibilityLabel: "Open External Link")
		}
		if let telegramName = dealer?.TelegramHandle, !telegramName.isEmpty {
			createSocialButton(icon: "\u{f2c6}", action: #selector(openTelegramLink),
			                   accessibilityLabel: "Open Telegram Profile")
		}
		if let twitterName = dealer?.TwitterHandle, !twitterName.isEmpty {
			createSocialButton(icon: "\u{f081}", action: #selector(openTwitterLink),
			                   accessibilityLabel: "Open Twitter Profile")
		}
		socialButtonsView.isHidden = socialButtonsView.subviews.count == 2
	}

	private func setupShortDescription() {
		artistShortDescriptionLabel.text = replaceUnicodeNewlines(in: dealer?.ShortDescription)
		artistShortDescriptionLabel.sizeToFit()
	}

	private func setupAbout() {
		let aboutText = replaceUnicodeNewlines(in: dealer?.AboutTheArtistText)
		if let aboutText = aboutText, !aboutText.isEmpty {
			aboutArtistLabel.text = aboutText
		} else {
			// TODO: Externalise strings for i18n
			aboutArtistLabel.text = "The artist did not provide any information about themselves to be shown here."
		}
		aboutArtistLabel.sizeToFit()
	}

	private func setupArtPreview() {
		guard let artPreviewImage = dealer?.ArtPreviewImage else {
			artPreviewImageView.isHidden = true
			artPreviewCaption.isHidden = true
			return
		}

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

					strongSelf.artPreviewCaption.text = strongSelf.replaceUnicodeNewlines(in: strongSelf.dealer?.ArtPreviewCaption)
					strongSelf.artPreviewCaption.sizeToFit()
				}
			case .failure:
				break
			}
		})
	}

	private func setupAboutArt() {
		let aboutArtText = replaceUnicodeNewlines(in: dealer?.AboutTheArtText)
		if let aboutArtText = aboutArtText, !aboutArtText.isEmpty {
			aboutArtLabel.text = aboutArtText
			aboutArtLabel.sizeToFit()
		} else {
			aboutArtLabel.isHidden = true

			// if neither text nor image have been provided, hide the entire about art section
			if artPreviewImageView.isHidden {
				aboutArtSpacerView.isHidden = true
				aboutArtTitleLabel.isHidden = true
			}
		}
	}

	private func setupMapImage() {
		guard let mapEntry = dealer?.MapEntry, let map = mapEntry.Map,
			let mapImage = map.Image else {
				dealersDenMapImageView.image = #imageLiteral(resourceName: "ef")
				return
		}

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

					DispatchQueue.main.async {
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
				}
			case .failure:
				break
			}
		})
	}

	// MARK: Private

	private func replaceUnicodeNewlines(in text: String?) -> String? {
		return text?.utf16.split { CharacterSet.newlines.contains(UnicodeScalar($0)!) }
			.flatMap(String.init).joined(separator: "\n")
	}

	private func createSocialButton(icon: String, action: Selector, accessibilityLabel: String) {
		let socialButton = UIButton(type: .system)
		let widthConstraint = NSLayoutConstraint(item: socialButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 40)
		let heightConstraint = NSLayoutConstraint(item: socialButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 40)
		socialButton.addConstraint(widthConstraint)
		socialButton.addConstraint(heightConstraint)
		socialButton.accessibilityLabel = accessibilityLabel
		socialButton.setTitle(icon, for: .normal)
		socialButton.titleLabel?.font = UIFont(name: "FontAwesome", size: 35.0)
		socialButton.addTarget(self, action: action, for: .primaryActionTriggered)
		socialButtonsView.addSubview(socialButton)
		socialButtonsView.insertArrangedSubview(socialButton, at: 1)
	}

	private func open(link: URL?) {
		guard let link = link else { return }

        attemptOpening(for: link) { (handled) in
            if !handled {
                let viewController = SFSafariViewController(url: link)
                self.present(viewController, animated: true)
            }
        }
	}

    private func attemptOpening(for url: URL, completionHandler: @escaping (Bool) -> Void) {
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url,
                                      options: [UIApplicationOpenURLOptionUniversalLinksOnly: true],
                                      completionHandler: completionHandler)
        } else {
            completionHandler(UIApplication.shared.openURL(url))
        }
    }

	// MARK: Actions

	func openTelegramLink() {
		guard let telegramHandle = dealer?.TelegramHandle else { return }

		let telegramLink = DealerViewController.telegramLinkBase.appending(telegramHandle)
		let telegramUrl = URL(string: telegramLink)

		open(link: telegramUrl)
	}

	func openTwitterLink() {
		guard let twitterHandle = dealer?.TwitterHandle else { return }

		let twitterLink = DealerViewController.twitterLinkBase.appending(twitterHandle)
        open(link: URL(string: twitterLink))
	}

	func openExternalLink() {
		guard let links = dealer?.Links, links.count > 0 else { return }

		let linkFragment = links[0]

		switch linkFragment.FragmentType {
		case .WebExternal:
			guard let linkUrl = URL(string: linkFragment.Target) else { return }
			open(link: linkUrl)
		default:
			return
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
