//
//  LocalizedStrings.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 09/01/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

public extension String {

    public static let ok = string("ok", comment: "OK")
    public static let cancel = string("cancel", comment: "Cancel")
    public static let tryAgain = string("tryAgain", comment: "Try Again")

    public static let tutorialPushPermissionsRequestTitle = string("tutorialPushPermissionsRequestTitle", comment: "Push permissions tutorial page title")
    public static let tutorialPushPermissionsRequestDescription = string("tutorialPushPermissionsRequestDescription", comment: "Push permissions tutorial page description")
    public static let tutorialAllowPushPermissions = string("tutorialAllowPushPermissions", comment: "Allow Notifications")
    public static let tutorialDenyPushPermissions = string("tutorialDenyPushPermissions", comment: "No Thanks")

    public static let tutorialInitialLoadTitle = string("tutorialInitialLoadTitle", comment: "Required download tutorial page title")
    public static let tutorialInitialLoadDescription = string("tutorialInitialLoadDescription", comment: "Required download tutorial page description")
    public static let tutorialInitialLoadBeginDownload = string("tutorialInitialLoadBeginDownload", comment: "Begin Download")

    public static let cellularDownloadAlertTitle = string("cellularDownloadAlertTitle", comment: "Use Cellular Data?")
    public static let cellularDownloadAlertMessage = string("cellularDownloadAlertMessage", comment: "Warning about continuing with the download over cellular")
    public static let cellularDownloadAlertContinueOverCellularTitle = string("cellularDownloadAlertContinueOverCellularTitle", comment: "Continue Over Cellular")

    public static let downloadError = string("downloadError", comment: "Download Error")
    public static let preloadFailureMessage = string("preloadFailureMessage", comment: "Failed to download data from server. Please try again.")

    public static let anonymousUserLoginPrompt = string("anonymousUserLoginPrompt", comment: "Tells user to login for additional features")
    public static let anonymousUserLoginDescription = string("anonymousUserLoginDescription", comment: "Additional information for logged out users")

    public static let authenticatedUserLoginPromptFormat = string("authenticatedUserLoginPromptFormat", comment: "Prompt displayed for logged in users, showing their username and registration number")

    public static let loggingIn = string("loggingIn", comment: "Logging In")
    public static let loggingInDetail = string("loggingInDetail", comment: "This may take a few moments")
    public static let loginError = string("loginError", comment: "Login Error")
    public static let loginErrorDetail = string("loginErrorDetail", comment: "Please verify your login details and make sure you are connected to the internet")

    public static let messages = string("Messages", comment: "Messages")

    internal static func welcomePrompt(for user: User) -> String {
        return localizedStringWithFormat(authenticatedUserLoginPromptFormat, user.username, user.registrationNumber)
    }

    private static func string(_ key: String, comment: String) -> String {
        return NSLocalizedString(key, tableName: "Strings", bundle: .main, comment: comment)
    }

}
