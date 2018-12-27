//
//  CapturingScheduleDayComponent.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 13/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceModel
import Foundation

class CapturingScheduleDayComponent: ScheduleDayComponent {

    private(set) var capturedTitle: String?
    func setDayTitle(_ title: String) {
        capturedTitle = title
    }

}
