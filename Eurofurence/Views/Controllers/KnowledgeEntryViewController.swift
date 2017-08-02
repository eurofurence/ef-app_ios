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
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var linkLabel: UILabel!
    @IBOutlet weak var linkView: UIStackView!

	let imageService: ImageServiceProtocol = try! ServiceResolver.container.resolve()
	weak var knowledgeEntry = KnowledgeEntry()
	var disposables = CompositeDisposable()

	// TODO: This is somewhat nasty and might require refactoring at some point
    var buttonLinks: [UIButton:LinkFragment] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()

		view.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "Background Tile"))

		textView.textContainer.lineFragmentPadding = 0.0

        clearLinks()
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

		imageView.image = #imageLiteral(resourceName: "ef")
        // TODO: How should multiple images be handled?
        if let image = knowledgeEntry?.Images?.first {
			imageView.isHidden = false
			imageService.retrieve(for: image).startWithResult({ [unowned self] result in
				switch result {
				case let .success(uiImage):
					DispatchQueue.main.async {
						self.imageView.image = uiImage
					}
				case let .failure(error):
					print("Failed to retrieve image for KnowledgeEntry \(self.knowledgeEntry?.Title ?? ""): \(error)")
				}
			})
		} else {
			imageView.isHidden = true
		}

		textView.attributedText = WikiText.transform(knowledgeEntry?.Text ?? "")

        clearLinks()

		if let links = knowledgeEntry?.Links {
			for knowledgeLink in links {
				addLinkButton(knowledgeLink)
			}
		}

		linkLabel.isHidden = buttonLinks.count == 0
		linkView.isHidden = buttonLinks.count == 0
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
			case .MapEntry:
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
		linkButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .body)
        linkButton.accessibilityIdentifier = linkFragment.Name
        linkButton.addTarget(self, action: #selector(KnowledgeEntryViewController.urlButtonAction(_:)), for: .touchUpInside)

		linkView.addArrangedSubview(linkButton)
        linkView.addSubview(linkButton)
        buttonLinks[linkButton] = linkFragment
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

	private func clearLinks() {
		for subview in linkView.subviews {
			linkView.removeArrangedSubview(subview)
			subview.removeFromSuperview()
		}
		buttonLinks = [:]
	}
}
