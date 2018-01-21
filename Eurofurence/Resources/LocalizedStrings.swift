//
//  LocalizedStrings.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 09/01/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

public extension String {

    private static let tableName = "Strings"
    private static let tableBundle = Bundle.main

    public static let ok = NSLocalizedString("ok",
                                             comment: "OK")

    public static let cancel = NSLocalizedString("cancel",
                                                 comment: "Cancel")

    public static let tryAgain = NSLocalizedString("tryAgain",
                                                   comment: "Try Again")

    public static let tutorialPushPermissionsRequestTitle = NSLocalizedString("tutorialPushPermissionsRequestTitle",
                                                                              comment: "Push permissions tutorial page title")

    public static let tutorialPushPermissionsRequestDescription = NSLocalizedString("tutorialPushPermissionsRequestDescription",
                                                                                    comment: "Push permissions tutorial page description")

    public static let tutorialAllowPushPermissions = NSLocalizedString("tutorialAllowPushPermissions",
                                                                       comment: "Allow Notifications")

    public static let tutorialDenyPushPermissions = NSLocalizedString("tutorialDenyPushPermissions",
                                                                      comment: "No Thanks")

    public static let tutorialInitialLoadTitle = NSLocalizedString("tutorialInitialLoadTitle",
                                                                   comment: "Required download tutorial page title")

    public static let tutorialInitialLoadDescription = NSLocalizedString("tutorialInitialLoadDescription",
                                                                         comment: "Required download tutorial page description")

    public static let tutorialInitialLoadBeginDownload = NSLocalizedString("tutorialInitialLoadBeginDownload",
                                                                           comment: "Begin Download")

    public static let cellularDownloadAlertTitle = NSLocalizedString("cellularDownloadAlertTitle",
                                                                     comment: "Use Cellular Data?")

    public static let cellularDownloadAlertMessage = NSLocalizedString("cellularDownloadAlertMessage",
                                                                       comment: "Warning about continuing with the download over cellular")

    public static let cellularDownloadAlertContinueOverCellularTitle = NSLocalizedString("cellularDownloadAlertContinueOverCellularTitle",
                                                                                         comment: "Continue Over Cellular")

    public static let downloadError = NSLocalizedString("downloadError",
                                                        comment: "Download Error")

    public static let preloadFailureMessage = NSLocalizedString("preloadFailureMessage",
                                                                comment: "Failed to download data from server. Please try again.")

    public static let anonymousUserLoginPrompt = NSLocalizedString("anonymousUserLoginPrompt",
                                                                   comment: "Tells user to login for additional features")

    public static let anonymousUserLoginDescription = NSLocalizedString("anonymousUserLoginDescription",
                                                                        comment: "Additional information for logged out users")

    public static let authenticatedUserLoginPromptFormat = NSLocalizedString("authenticatedUserLoginPromptFormat",
                                                                             comment: "Prompt displayed for logged in users, showing their username and registration number")

    public static let authentiatedUserLoginDescriptionFormat = NSLocalizedString("authentiatedUserLoginDescriptionFormat",
                                                                                 comment: "Prompt displayed to logged in users telling them how many unread messages they have")

    public static let login = NSLocalizedString("login",
                                                comment: "Title displayed on the view asking the user to input their login details")

    public static let loggingIn = NSLocalizedString("loggingIn",
                                                    comment: "Logging In")

    public static let loggingInDetail = NSLocalizedString("loggingInDetail",
                                                          comment: "This may take a few moments")

    public static let loginError = NSLocalizedString("loginError",
                                                     comment: "Login Error")

    public static let loginErrorDetail = NSLocalizedString("loginErrorDetail",
                                                           comment: "Please verify your login details and make sure you are connected to the internet")

    public static let messages = NSLocalizedString("Messages",
                                                   comment: "Messages")

    private struct Formatters {
        static var numbers = NumberFormatter()
    }

    internal static func welcomePrompt(for user: User) -> String {
        return localizedStringWithFormat(authenticatedUserLoginPromptFormat,
                                         user.username,
                                         Formatters.numbers.string(from: NSNumber(value: user.registrationNumber))!)
    }

    internal static func welcomeDescription(messageCount: Int) -> String {
        return localizedStringWithFormat(authentiatedUserLoginDescriptionFormat,
                                         Formatters.numbers.string(from: NSNumber(value: messageCount))!)
    }

}
