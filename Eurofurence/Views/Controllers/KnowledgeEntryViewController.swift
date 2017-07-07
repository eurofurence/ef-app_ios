//
//  KnowledgeEntryViewController.swift
//  Eurofurence
//
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import UIKit

class KnowledgeEntryViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var linkLabel: UILabel!
    @IBOutlet weak var linkView: UIView!

	weak var knowledgeEntry = KnowledgeEntry()
    var imageViewDefaultHeight = CGFloat(0.0)
    var linkViewLastButton: UIButton?
    var linkViewLastBottomConstraint: NSLayoutConstraint?
	// TODO: This is somewhat nasty and might require refactoring at some point
    var buttonLinks: [UIButton:LinkFragment] = [:]

    static let htmlStyle = "<style>"
        + "html, p, ul, li { font: -apple-system-body; color: #FFF; }"
        + "h1 { font: -apple-system-headline; color: #FFF; }"
        + "h2 { font: -apple-system-subheadline; color: #FFF; }"
        + "h3 { font: -apple-system-body; color: #FFF; }"
        + "h4 { font: -apple-system-body; color: #FFF; }"
        + "</style>"

    override func viewDidLoad() {
        super.viewDidLoad()

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

		navigationItem.title = knowledgeEntry?.KnowledgeGroup?.Name
        titleLabel.text = knowledgeEntry?.Title

        // TODO: how are images handled in KnowledgeEntry? 
//        if let imageId = knowledgeEntry.imageIdsAlternative.first {
//            imageView.image = ImageManager.sharedInstance.retrieveFromCache(imageId.Id)
//            if imageViewDefaultHeight > 0 {
//                imageViewHeightConstraint.constant = imageViewDefaultHeight
//            }
//        } else {
            imageView.image = nil
            if imageViewDefaultHeight == 0 {
                imageViewDefaultHeight = imageViewHeightConstraint.constant
            }
            imageViewHeightConstraint.constant = 0.0
//        }
        imageView.sizeToFit()

        do {
            let htmlText = WikiText.transformToHtml(knowledgeEntry?.Text ?? "", style: KnowledgeEntryViewController.htmlStyle)
			// FIXME: This somehow seems to trigger initialisation of a WebView inside textView, causing severe lag upon first call
            textView.attributedText = try NSAttributedString(
                data: htmlText.data(using: String.Encoding.unicode, allowLossyConversion: true)!,
                options: [ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
                documentAttributes: nil)
        } catch {
            textView.text = knowledgeEntry?.Text
        }

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
