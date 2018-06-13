//
//  CapturingScheduleEventComponent.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 13/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import Foundation

class CapturingScheduleEventComponent: ScheduleEventComponent {
    
    private(set) var capturedEventTitle: String?
    func setEventTitle(_ title: String) {
        capturedEventTitle = title
    }
    
}
