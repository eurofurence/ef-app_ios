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
    @IBOutlet weak var quoteAuthorLabel: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!

    // MARK: Overrides

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

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
        quoteAuthorLabel.text = author
    }

    func showProgress(_ progress: Float) {
        progressBar.setProgress(progress, animated: true)
    }

}
