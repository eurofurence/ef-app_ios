//
//  AnnouncementViewController.swift
//  Eurofurence
//
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import UIKit

class AnnouncementViewController: UIViewController {
	weak var announcement: Announcement?
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
        titleLabel.text = announcement?.Title
        areaLabel.text = announcement?.Area
        authorLabel.text = announcement?.Author
        descriptionLabel.text = announcement?.Content
		if let announcement = announcement {
			self.lastChangeLabel.text = DateFormatter.localizedString(
				from: announcement.LastChangeDateTimeUtc as Date, dateStyle: DateFormatter.Style.medium,
				timeStyle: DateFormatter.Style.short)
		} else {
			lastChangeLabel.text = nil
		}
    }

	// MARK: - Previewing
	lazy var previewActions: [UIPreviewActionItem] = {
		let readActionTitle = self.announcement?.IsRead ?? false ? "Mark as Unread" : "Mark as Read"
		let readAction = UIPreviewAction(title: readActionTitle, style: .default) { _, viewController in
			guard let announcementViewController = viewController as? AnnouncementViewController,
				let announcement = announcementViewController.announcement else { return }
			announcement.IsRead = !announcement.IsRead
			self.announcementsViewModel.saveAnnouncements()
		}
		return [readAction]
	}()

	override var previewActionItems: [UIPreviewActionItem] {
		return previewActions
	}
}
