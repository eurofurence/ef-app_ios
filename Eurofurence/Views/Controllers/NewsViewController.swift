//
//  NewsViewController.swift
//  Eurofurence
//
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import UIKit

class NewsViewController: UIViewController {
    var news = Announcement()
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var areaLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var lastChangeLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    func canRotate()->Bool {
        return true
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
        self.tabBarController?.tabBar.isHidden = true
        self.titleLabel.text = news.Title
        self.areaLabel.text = news.Area
        self.authorLabel.text = news.Author
        self.lastChangeLabel.text = DateFormatter.localizedString(
            from: news.LastChangeDateTimeUtc as Date, dateStyle: DateFormatter.Style.medium,
            timeStyle: DateFormatter.Style.short)
        self.descriptionLabel.text = news.Content
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
