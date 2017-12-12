//
//  MessageDetailViewControllerV2.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 12/12/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import UIKit.UIViewController

class MessageDetailViewControllerV2: UIViewController, MessageDetailScene {

    var delegate: MessageDetailSceneDelegate?

    func setMessageDetailTitle(_ title: String) {
        super.title = title
    }

    func setMessageSubject(_ subject: String) {

    }

    func setMessageContents(_ contents: String) {

    }

}
