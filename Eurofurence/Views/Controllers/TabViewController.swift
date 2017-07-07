//
//  TabViewController.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 07/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import UIKit

class TabViewController: UITabBarController {

    lazy var progressView: UIProgressView = UIProgressView(progressViewStyle: .bar)

    override func viewDidLoad() {
        super.viewDidLoad()

        progressView.alpha = 0
        progressView.isHidden = false
        progressView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(progressView)

        let views = ["Progress": progressView, "TabBar": tabBar] as [String : UIView]
        let visualFormats = ["H:|[Progress]|", "V:[Progress][TabBar]"]
        let constraints = visualFormats.map({ NSLayoutConstraint.constraints(withVisualFormat: $0,
                                                                             options: [.alignAllCenterX],
                                                                             metrics: nil,
                                                                             views: views) })
        view.addConstraints(constraints.reduce([], { $0 + $1 }))

        let refreshingDelegate = ProgressViewRefreshDelegate(progressView: progressView)
        DataStoreRefreshController.shared.add(refreshingDelegate)
    }

}
