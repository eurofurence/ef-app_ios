//
//  CapturingAnnouncementsScene.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 02/07/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceAppCore
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
    private(set) var binder: AnnouncementsBinder?
    func bind(numberOfAnnouncements: Int, using binder: AnnouncementsBinder) {
        capturedAnnouncementsToBind = numberOfAnnouncements
        self.binder = binder
    }
    
    private(set) var capturedAnnouncementIndexToDeselect: Int?
    func deselectAnnouncement(at index: Int) {
        capturedAnnouncementIndexToDeselect = index
    }
    
}
