//
//  PresentationStrings.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 10/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation

protocol PresentationStrings {

    func presentationString(for scenario: PresentationScenario) -> String

}

extension PresentationStrings {

    subscript (scenario: PresentationScenario) -> String {
        get {
            return presentationString(for: scenario)
        }
    }

}

enum PresentationScenario {
    case cancel
    case tryAgain

    case tutorialPushPermissionsRequestTitle
    case tutorialPushPermissionsRequestDescription
    case tutorialAllowPushPermissions
    case tutorialDenyPushPermissions

    case tutorialInitialLoadTitle
    case tutorialInitialLoadDescription
    case tutorialInitialLoadBeginDownload

    case cellularDownloadAlertTitle
    case cellularDownloadAlertMessage
    case cellularDownloadAlertContinueOverCellularTitle

    case downloadError
    case preloadFailureMessage

    case loggingIn
    case loggingInDetail
    case loginError
}

struct UnlocalizedPresentationStrings: PresentationStrings {

    private static let strings: [PresentationScenario : String] = [
        .cancel: "Cancel",
        .tryAgain: "",

        .tutorialPushPermissionsRequestTitle: "Push Notifications",
        .tutorialPushPermissionsRequestDescription: "To keep you up-to-date with changes to the event schedule and other important announcements, the app requires your permission to display notifications on your device.",
        .tutorialAllowPushPermissions: "Allow Notifications",
        .tutorialDenyPushPermissions: "No Thanks",

        .tutorialInitialLoadTitle: "Offline Usage",
        .tutorialInitialLoadDescription: "The Eurofurence app is intended to remain fully functional while offline. To do this, we need to download a few megabytes of data. This may take several minutes depending upon the speed of your connection.",
        .tutorialInitialLoadBeginDownload: "Begin Download",

        .cellularDownloadAlertTitle: "Use Cellular Data?",
        .cellularDownloadAlertMessage: "Proceeding with the initial download will consume several megabytes of data.",
        .cellularDownloadAlertContinueOverCellularTitle: "Continue Over Cellular",

        .downloadError: "Download Error",
        .preloadFailureMessage: "Failed to download data from server. Please try again.",
        .loggingIn: "",
        .loggingInDetail: "",
        .loginError: ""
    ]

    func presentationString(for scenario: PresentationScenario) -> String {
        return UnlocalizedPresentationStrings.strings[scenario]!
    }

}
