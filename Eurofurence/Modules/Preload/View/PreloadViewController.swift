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

    @IBOutlet weak var progressBar: UIProgressView!

    // MARK: Overrides

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .pantone330U
        progressBar.trackTintColor = .pantone330U_45
        progressBar.progressTintColor = .white
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        delegate?.splashSceneWillAppear(self)
    }

    // MARK: SplashScene

    var delegate: SplashSceneDelegate?

    func showProgress(_ progress: Float) {
        progressBar.setProgress(progress, animated: true)
    }

}
