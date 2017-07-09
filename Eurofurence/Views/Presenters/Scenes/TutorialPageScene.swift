//
//  TutorialPageScene.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 09/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation
import UIKit

protocol TutorialPageScene {

    func showPageTitle(_ title: String?)
    func showPageDescription(_ description: String?)
    func showPageImage(_ image: UIImage?)

    func showPrimaryActionButton()
    func showPrimaryActionDescription(_ primaryActionDescription: String)

}
