//
//  CapturingAnnouncementsScene.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 02/07/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import UIKit

class CapturingAnnouncementsScene: UIViewController, AnnouncementsScene {
    
    private(set) var delegate: AnnouncementsSceneDelegate?
    func setDelegate(_ delegate: AnnouncementsSceneDelegate) {
        self.delegate = delegate
    }
    
    private(set) var capturedTitle: String?
    func setAnnouncementsTitle(_ title: String) {
        capturedTitle = title
    }
    
    private(set) var capturedAnnouncementsToBind: Int?
    func bind(numberOfAnnouncements: Int) {
        capturedAnnouncementsToBind = numberOfAnnouncements
    }
    
}
