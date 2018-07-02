//
//  CapturingAnnouncementComponent.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 02/07/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import Foundation

class CapturingAnnouncementComponent: AnnouncementComponent {
    
    private(set) var capturedTitle: String?
    func setAnnouncementTitle(_ title: String) {
        capturedTitle = title
    }
    
    private(set) var capturedDetail: String?
    func setAnnouncementDetail(_ detail: String) {
        capturedDetail = detail
    }
    
    private(set) var didHideUnreadIndicator = false
    func hideUnreadIndicator() {
        didHideUnreadIndicator = true
    }
    
    private(set) var didShowUnreadIndicator = false
    func showUnreadIndicator() {
        didShowUnreadIndicator = true
    }
    
}
