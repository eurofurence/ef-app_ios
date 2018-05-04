//
//  CapturingAnnouncementDetailScene.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 04/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import UIKit.UIViewController

class CapturingAnnouncementDetailScene: UIViewController, AnnouncementDetailScene {
    
    private(set) var capturedTitle: String?
    func setAnnouncementTitle(_ title: String) {
        capturedTitle = title
    }
    
}
