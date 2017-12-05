//
//  PreloadViewController.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 05/12/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import UIKit.UIViewController

class PreloadViewController: UIViewController, SplashScene {

    // MARK: IBOutlets

    @IBOutlet weak var quoteLabel: UILabel!

    // MARK: Overrides

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        delegate?.splashSceneWillAppear(self)
    }

    // MARK: SplashScene

    var delegate: SplashSceneDelegate?

    func showQuote(_ quote: String) {
        quoteLabel.text = quote
    }

    func showQuoteAuthor(_ author: String) {

    }

    func showProgress(_ progress: Float) {

    }

}
