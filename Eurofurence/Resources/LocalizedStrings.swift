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
                                             comment: "Affirmative action used by prompts to accept an action")

    public static let cancel = NSLocalizedString("cancel",
                                                 comment: "Negative action used by prompts to decline an action")

    public static let tryAgain = NSLocalizedString("tryAgain",
                                                   comment: "Used by prompts when an action fails, re-instigating the failed task")

    public static let tutorialPushPermissionsRequestTitle = NSLocalizedString("tutorialPushPermissionsRequestTitle",
                                                                              comment: "Title used in the tutorial when asking for push permissions from the user")

    public static let tutorialPushPermissionsRequestDescription = NSLocalizedString("tutorialPushPermissionsRequestDescription",
                                                                                    comment: "Description used in the tutorial when asking for push permissions from the user")

    public static let tutorialAllowPushPermissions = NSLocalizedString("tutorialAllowPushPermissions",
                                                                       comment: "Text used in the button where the user allows us to send them push notifications")

    public static let tutorialDenyPushPermissions = NSLocalizedString("tutorialDenyPushPermissions",
                                                                      comment: "Text used in the button where the user does not allow us to send them push notifications")

    public static let tutorialInitialLoadTitle = NSLocalizedString("tutorialInitialLoadTitle",
                                                                   comment: "Title used in the tutorial telling the user we need to perform the initial download before they can use the app")

    public static let tutorialInitialLoadDescription = NSLocalizedString("tutorialInitialLoadDescription",
                                                                         comment: "Description used in the tutorial telling the user we need to perform the initial download before they can use the app")

    public static let tutorialInitialLoadBeginDownload = NSLocalizedString("tutorialInitialLoadBeginDownload",
                                                                           comment: "Text used in the button where the user allows us to begin the initial download")

    public static let cellularDownloadAlertTitle = NSLocalizedString("cellularDownloadAlertTitle",
                                                                     comment: "Title for the prompt asking if the user wants to perform the initial download over cellular data")

    public static let cellularDownloadAlertMessage = NSLocalizedString("cellularDownloadAlertMessage",
                                                                       comment: "Description for the prompt asking if the user wants to perform the initial download over cellular data")

    public static let cellularDownloadAlertContinueOverCellularTitle = NSLocalizedString("cellularDownloadAlertContinueOverCellularTitle",
                                                                                         comment: "Confirmation action allowing the initial download to begin over cellular")

    public static let downloadError = NSLocalizedString("downloadError",
                                                        comment: "Title for the alert when the download fails")

    public static let preloadFailureMessage = NSLocalizedString("preloadFailureMessage",
                                                                comment: "Description for the alert when the download fails")

    public static let news = NSLocalizedString("News", comment: "The title shown for the News view")

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
                                                    comment: "Title for the alert displayed as we're logging the user in")

    public static let loggingInDetail = NSLocalizedString("loggingInDetail",
                                                          comment: "Description for the alert displayed as we're logging the user in")

    public static let loginError = NSLocalizedString("loginError",
                                                     comment: "Title for the alert displayed when we're unable to log the user in")

    public static let loginErrorDetail = NSLocalizedString("loginErrorDetail",
                                                           comment: "Description for the alert displayed when we're unable to log the user in")

    public static let messages = NSLocalizedString("Messages",
                                                   comment: "Title for the view that displays the user's private messages")

    public static let events = NSLocalizedString("Events",
                                                 comment: "Title for the view that shows all the events during the convention")

    public static let conventionInformation = NSLocalizedString("ConventionInformation",
                                                                comment: "Title for the view showing all the categorised convention information")

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
