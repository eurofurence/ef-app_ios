//
//  CapturingScheduleEventGroupHeader.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 13/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import Foundation

class CapturingScheduleEventGroupHeader: ScheduleEventGroupHeader {
    
    private(set) var capturedTitle: String?
    func setEventGroupTitle(_ title: String) {
        capturedTitle = title
    }
    
}
