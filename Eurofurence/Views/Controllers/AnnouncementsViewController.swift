//
//  AnnouncementsViewController.swift
//  Eurofurence
//
//  Created by Dominik Schöner on 2017-05-06.
//  Copyright © 2017 Dominik Schöner. All rights reserved.
//

import Result
import ReactiveCocoa
import ReactiveSwift
import UIKit

class AnnouncementsViewController: UIViewController {

    private var viewModel: AnnouncementsViewModel = try! ViewModelResolver.container.resolve()

    override func viewDidLoad() {
        super.viewDidLoad()

	    let textView = UITextView()
	    textView.reactive.text <~ viewModel.Announcements.map({ announcements in
		    if let announcement = announcements.last as Announcement? {
			    return announcement.Title
		    } else {
			    return "Nothing to see here."
		    }
	    })
	    self.view.addSubview(textView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

