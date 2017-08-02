//
//  KnowledgeEntryViewController.swift
//  Eurofurence
//
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import UIKit
import ReactiveSwift

class KnowledgeEntryViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var linkLabel: UILabel!
    @IBOutlet weak var linkView: UIView!

	let imageService: ImageServiceProtocol = try! ServiceResolver.container.resolve()
	weak var knowledgeEntry = KnowledgeEntry()
	var disposables = CompositeDisposable()

    var imageViewDefaultHeight = CGFloat(0.0)
    var linkViewLastButton: UIButton?
    var linkViewLastBottomConstraint: NSLayoutConstraint?
	// TODO: This is somewhat nasty and might require refactoring at some point
    var buttonLinks: [UIButton:LinkFragment] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()

		view.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "Background Tile"))

        linkView.translatesAutoresizingMaskIntoConstraints = false
        for subview in linkView.subviews {
            subview.removeFromSuperview()
        }
    }

    func canRotate() -> Bool {
        return true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

		if !disposables.isDisposed {
			disposables.dispose()
		}
		disposables = CompositeDisposable()

		navigationItem.title = knowledgeEntry?.KnowledgeGroup?.Name
        titleLabel.text = knowledgeEntry?.Title

        // TODO: How should multiple images be handled?
        if let image = knowledgeEntry?.Images?.first {
			imageService.retrieve(for: image).startWithResult({ [unowned self] result in
				switch result {
				case let .success(uiImage):
					DispatchQueue.main.async {
						self.imageView.image = uiImage
						if self.imageViewDefaultHeight > 0 {
							self.imageViewHeightConstraint.constant = self.imageViewDefaultHeight
						}
					}
				case let .failure(error):
					print("Failed to retrieve image for KnowledgeEntry \(self.knowledgeEntry?.Title ?? ""): \(error)")
				}
			})
        }

		imageView.image = nil
		if imageViewDefaultHeight == 0 {
			imageViewDefaultHeight = imageViewHeightConstraint.constant
		}
		imageViewHeightConstraint.constant = 0.0
        imageView.sizeToFit()

		textView.attributedText = WikiText.transform(knowledgeEntry?.Text ?? "")

        for subview in linkView.subviews {
            subview.removeFromSuperview()
        }
        linkViewLastButton = nil
        linkViewLastBottomConstraint = nil
        buttonLinks = [:]

        linkView.translatesAutoresizingMaskIntoConstraints = false
		if let links = knowledgeEntry?.Links {
			for knowledgeLink in links {
				addLinkButton(knowledgeLink)
			}
		}

        linkLabel.isHidden = buttonLinks.count == 0
    }

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)

		disposables.dispose()
	}

    func urlButtonAction(_ button: UIButton) {
        if let link = buttonLinks[button] {
			switch link.FragmentType {
			case .DealerDetail:
				if let dealer: Dealer = link.getTarget() {
					performSegue(withIdentifier: "KnowledgeEntryToDealerSegue", sender: dealer)
				}
			case .MapInternal:
				if let mapEntry: MapEntry = link.getTarget() {
					performSegue(withIdentifier: "KnowledgeEntryToMapSegue", sender: mapEntry)
				}
			case .WebExternal:
				if let url: URL = link.getTarget() {
					UIApplication.shared.openURL(url)
				}
			default:
				// TODO: Provide option for .MapExternal
				break
			}
        }
    }

    func addLinkButton(_ linkFragment: LinkFragment) {
        let linkButton = UIButton(type: UIButtonType.roundedRect)
        linkButton.setTitle(linkFragment.Name, for: UIControlState())
        linkButton.accessibilityIdentifier = linkFragment.Name
        linkButton.translatesAutoresizingMaskIntoConstraints = false
        linkButton.addTarget(self, action: #selector(KnowledgeEntryViewController.urlButtonAction(_:)), for: .touchUpInside)

        linkView.addSubview(linkButton)

        if linkViewLastButton != nil {
            if linkViewLastBottomConstraint != nil {
                linkView.removeConstraint(linkViewLastBottomConstraint!)
            }
            // Top Constraint -> lastButton.Bottom
            NSLayoutConstraint(item: linkButton, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: linkViewLastButton, attribute: NSLayoutAttribute.bottom, multiplier: 1.0, constant: 4).isActive = true
        } else {
            // Top Constraint -> view.TopMargin
            NSLayoutConstraint(item: linkButton, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: linkView, attribute: NSLayoutAttribute.topMargin, multiplier: 1.0, constant: 0).isActive = true
        }
        // Bottom Constraint -> view.Bottom
        linkViewLastBottomConstraint = NSLayoutConstraint(item: linkButton, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: linkView, attribute: NSLayoutAttribute.bottomMargin, multiplier: 1.0, constant: 0)
        linkViewLastBottomConstraint!.isActive = true
        // Leading Constraint -> view.LeadingMargin
        NSLayoutConstraint(item: linkButton, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: linkView, attribute: NSLayoutAttribute.leadingMargin, multiplier: 1.0, constant: 0).isActive = true
        // Trailing Constraint -> view.TrailingMargin
        NSLayoutConstraint(item: linkButton, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: linkView, attribute: NSLayoutAttribute.trailingMargin, multiplier: 1.0, constant: 0).isActive = true

        linkViewLastButton = linkButton
        buttonLinks[linkButton] = linkFragment

        linkView.layoutSubviews()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		guard let identifier = segue.identifier else { return }

		switch identifier {
		case "KnowledgeEntryToDealerSegue":
			if let destinationVC = segue.destination as? DealerViewController, let dealer = sender as? Dealer {
				destinationVC.dealer = dealer
			}
		case "KnowledgeEntryToMapSegue":
			if let destinationVC = segue.destination as? MapViewController, let mapEntry = sender as? MapEntry {
				destinationVC.mapEntry = mapEntry
				destinationVC.currentMapEntryRadiusMultiplier = 10.0
			}
		default:
			break
		}
	}
}
