//
//  PreloadViewController.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 05/12/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import UIKit.UIViewController

class PreloadViewController: UIViewController, SplashScene {

    // MARK: Private

    private struct Quips {

        private static var allQuips: [String] {
            return [.solvingPNP]
        }

        static var random: String {
            let upper = Int(arc4random_uniform(UInt32(allQuips.count)))
            return allQuips[upper]
        }

    }

    // MARK: IBOutlets

    @IBOutlet weak var progressDescriptionLabel: UILabel!
    @IBOutlet weak var randomQuipLabel: UILabel!

    // MARK: Overrides

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .pantone330U
        progressDescriptionLabel.textColor = .white
        randomQuipLabel.text = Quips.random
        randomQuipLabel.textColor = .white
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        delegate?.splashSceneWillAppear(self)
    }

    // MARK: SplashScene

    var delegate: SplashSceneDelegate?

    func showProgress(_ progress: Float, progressDescription: String) {
        progressDescriptionLabel.text = progressDescription
    }

}
