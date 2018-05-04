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
    
    private(set) var delegate: AnnouncementDetailSceneDelegate?
    func setDelegate(_ delegate: AnnouncementDetailSceneDelegate) {
        self.delegate = delegate
    }
    
    private(set) var capturedTitle: String?
    func setAnnouncementTitle(_ title: String) {
        capturedTitle = title
    }
    
    private(set) var capturedAnnouncementHeading: String?
    func setAnnouncementHeading(_ heading: String) {
        capturedAnnouncementHeading = heading
    }
    
    private(set) var capturedAnnouncementContents: NSAttributedString?
    func setAnnouncementContents(_ contents: NSAttributedString) {
        capturedAnnouncementContents = contents
    }
    
}
