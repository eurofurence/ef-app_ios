//
//  StubPresentationStrings.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 10/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import Foundation

class StubPresentationStrings: PresentationStrings {

    private var strings = [PresentationScenario : String]()

    init() {
        stub("Tutorial initial load title", for: .tutorialInitialLoadTitle)
    }

    private func stub(_ string: String, for scenario: PresentationScenario) {
        strings[scenario] = string
    }

    func presentationString(for scenario: PresentationScenario) -> String? {
        return strings[scenario]
    }

}
