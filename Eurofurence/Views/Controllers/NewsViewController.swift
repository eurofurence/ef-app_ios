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

    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */

}
