//
//  NewsViewController.swift
//  Eurofurence
//
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import UIKit

class NewsViewController: UIViewController {
	weak var news: Announcement?
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var areaLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var lastChangeLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UITextView!

	private var announcementsViewModel: AnnouncementsViewModel = try! ViewModelResolver.container.resolve()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    func canRotate() -> Bool {
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        titleLabel.text = news?.Title
        areaLabel.text = news?.Area
        authorLabel.text = news?.Author
        descriptionLabel.text = news?.Content
		if let news = news {
			self.lastChangeLabel.text = DateFormatter.localizedString(
				from: news.LastChangeDateTimeUtc as Date, dateStyle: DateFormatter.Style.medium,
				timeStyle: DateFormatter.Style.short)
		} else {
			lastChangeLabel.text = nil
		}
    }

	// MARK: - Previewing
	lazy var previewActions: [UIPreviewActionItem] = {
		let readActionTitle = self.news?.IsRead ?? false ? "Mark as Unread" : "Mark as Read"
		let readAction = UIPreviewAction(title: readActionTitle, style: .default) { _, viewController in
			guard let newsViewController = viewController as? NewsViewController,
				let news = newsViewController.news else { return }
			news.IsRead = !news.IsRead
			self.announcementsViewModel.saveAnnouncements()
		}
		return [readAction]
	}()

	override var previewActionItems: [UIPreviewActionItem] {
		return previewActions
	}
}
