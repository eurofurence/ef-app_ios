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

enum PresentationScenario {
    case cancel

    case tutorialPushPermissionsRequestTitle
    case tutorialPushPermissionsRequestDescription

    case tutorialInitialLoadTitle
    case tutorialInitialLoadDescription
    case tutorialInitialLoadBeginDownload

    case cellularDownloadAlertTitle
    case cellularDownloadAlertMessage
    case cellularDownloadAlertContinueOverCellularTitle
}

struct UnlocalizedPresentationStrings: PresentationStrings {

    private static let strings: [PresentationScenario : String] = [
        .cancel: "Cancel",

        .tutorialPushPermissionsRequestTitle: "Push Notifications",
        .tutorialPushPermissionsRequestDescription: "",

        .tutorialInitialLoadTitle: "Offline Usage",
        .tutorialInitialLoadDescription: "The Eurofurence app is intended to remain fully functional while offline. To do this, we need to download a few megabytes of data. This may take several minutes depending upon the speed of your connection.",
        .tutorialInitialLoadBeginDownload: "Begin Download",

        .cellularDownloadAlertTitle: "Use Cellular Data?",
        .cellularDownloadAlertMessage: "Proceeding with the initial download will consume several megabytes of data.",
        .cellularDownloadAlertContinueOverCellularTitle: "Continue Over Cellular"
    ]

    func presentationString(for scenario: PresentationScenario) -> String {
        return UnlocalizedPresentationStrings.strings[scenario]!
    }

}
