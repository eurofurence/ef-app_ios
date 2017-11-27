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
        stub("Cancel", for: .cancel)
        stub("Tutorial push permissions request title", for: .tutorialPushPermissionsRequestTitle)
        stub("Tutorial push permissions request description", for: .tutorialPushPermissionsRequestDescription)
        stub("Tutorial allow push permissions", for: .tutorialAllowPushPermissions)
        stub("Tutorial deny push permissions", for: .tutorialDenyPushPermissions)
        stub("Tutorial initial load title", for: .tutorialInitialLoadTitle)
        stub("Tutorial initial load description", for: .tutorialInitialLoadDescription)
        stub("Tutorial initial load begin download", for: .tutorialInitialLoadBeginDownload)
        stub("Cellular download alert title", for: .cellularDownloadAlertTitle)
        stub("Cellular download alert message", for: .cellularDownloadAlertMessage)
        stub("Cellular download alert continue over cellular", for: .cellularDownloadAlertContinueOverCellularTitle)
        stub("Logging In", for: .loggingIn)
        stub("Logging In Detail", for: .loggingInDetail)
    }

    private func stub(_ string: String, for scenario: PresentationScenario) {
        strings[scenario] = string
    }

    func presentationString(for scenario: PresentationScenario) -> String {
        return strings[scenario]!
    }

}
