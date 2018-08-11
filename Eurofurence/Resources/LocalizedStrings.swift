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
    public static let yourEurofurence = NSLocalizedString("YourEurofurence",
                                                          comment: "Heading for the messages widget in the News tab")
    public static let announcements = NSLocalizedString("Announcements",
                                                        comment: "Heading for the announcements shown to the user in the News tab")
    public static let allAnnouncements = NSLocalizedString("AllAnnouncements",
                                                           comment: "Title for the component in the News view to show a list of all the announcements sent during the convention")
    public static let daysUntilConvention = NSLocalizedString("DaysUntilConventionHeader",
                                                              comment: "Header shown above the widget describing how many days are left until the convention")
    public static let daysRemainingFormat = NSLocalizedString("DaysUntilConvention",
                                                              comment: "Format strings substituted with the remaining number of days until the convention")
    public static let upcomingEvents = NSLocalizedString("UpcomingEvents",
                                                         comment: "Header shown above section in the News view for events that start soon")
    public static let runningEvents = NSLocalizedString("RunningEvents",
                                                        comment: "Header shown above section in the News view for events that are currently running")
    public static let todaysFavouriteEvents = NSLocalizedString("TodaysFavouriteEvents",
                                                                comment: "Header shown above section in the News view for events that the user has added to their favourites that are taking place today")
    public static let now = NSLocalizedString("Now",
                                              comment: "Shown in place of the event start time when the event is running now")

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

    public static let logout = NSLocalizedString("Logout",
                                                 comment: "Title for the bar button in the Messages tab allowing the user to log out of the app")

    public static let loggingOut = NSLocalizedString("LoggingOut",
                                                     comment: "Title for the alert shown when the user has requested to be logged out")

    public static let loggingOutAlertDetail = NSLocalizedString("LoggingOutAlertDetail",
                                                                comment: "Message for the alert shown when the user has requested to be logged out")

    public static let logoutFailed = NSLocalizedString("LogoutFailed",
                                                       comment: "Title for the alert shown when a user has requested to be logged out, but the app encountered an error")
    public static let logoutFailedAlertDetail = NSLocalizedString("LogoutFailedAlertDetail",
                                                                  comment: "Message for the alert shown when a user has requested to be logged out, but the app encountered an error")

    public static let messages = NSLocalizedString("Messages",
                                                   comment: "Title for the view that displays the user's private messages")

    public static let schedule = NSLocalizedString("Schedule",
                                                   comment: "Title for the view that shows the convention schedule")

    public static let dealers = NSLocalizedString("Dealers",
                                                  comment: "Title for the view that shows the dealers listed in the dealers den during the convention")

    public static let conventionInformation = NSLocalizedString("ConventionInformation",
                                                                comment: "Title for the view showing all the categorised convention information")

    public static let information = NSLocalizedString("Information",
                                                      comment: "Tab bar item title for the view showing all the categoried convention information")

    public static let announcement = NSLocalizedString("Announcement",
                                                       comment: "Title for the view showing detailed information for an announcement")

    public static let favourite = NSLocalizedString("Favourite",
                                                    comment: "Title for the button used to add an event to the user's favourites")

    public static let unfavourite = NSLocalizedString("Unfavourite",
                                                      comment: "Title for the button used to remove an event from the user's favourites")

    public static let locationAndAvailability = NSLocalizedString("LocationAndAvailability",
                                                                  comment: "Heading for component in the dealer detail view explaining their location, convention availability and their AD status")
    public static let locatedWithinAfterDarkDen = NSLocalizedString("LocatedWithinAfterDarkDen",
                                                                    comment: "Short sentence describing that the dealer is located within the after-dark dealers den")

    static let onlyPresentOnSpecificDaysFormat = NSLocalizedString("OnlyPresentOnSpecificDaysFormat",
                                                                   comment: "Text displayed with the days during the convention a dealer is present for, e.g. 'Thursday'")

    public static let aboutTheArtist = NSLocalizedString("AboutTheArtist",
                                                         comment: "Title for section in the Dealer Details screen showing the description provided by the artist")
    public static let aboutTheArtistPlaceholder = NSLocalizedString("AboutTheArtistPlaceholder",
                                                                    comment: "Placeholder text displayed in the Dealer Details screen when the artist did not provide a custom description about themselves")
    public static let aboutTheArt = NSLocalizedString("AboutTheArt",
                                                      comment: "Title for section in the Dealer Details screen showing the sample art provided by the dealer")

    public static let collect = NSLocalizedString("Collect",
                                                  comment: "Short title for the Collect-them-All screen shown in the tab bar")

    public static let collectThemAll = NSLocalizedString("CollectThemAll",
                                                         comment: "Title shown at the top of the Collect-them-All screen")

    public static let maps = NSLocalizedString("Maps",
                                               comment: "Title for the view containing the list of available convention maps")

    private static let eventReminderBodyFormat = NSLocalizedString("EventReminderBodyFormat",
                                                                   comment: "Format string used for event reminder notifications to tell the user when and where an upcoming event is taking place")

    public static let downloadingLatestData = NSLocalizedString("DownloadingLatestData",
                                                                comment: "Placeholder string displayed on the preload page to indicate to the user the app is updating")

    public static let allEvents = NSLocalizedString("AllEvents",
                                                    comment: "Title for the button used under the events search bar to search through all events")

    public static let favourites = NSLocalizedString("Favourites",
                                                     comment: "Title for the button used under the events search bar to search through only the user's favourites")

    public static let thisEventIsForSponsorsOnly = NSLocalizedString("ThisEventIsForSponsorsOnly",
                                                                     comment: "Message shown in the event detail view when viewing an event that's only available for attendees who are sponsors")

    public static let thisEventIsForSuperSponsorsOnly = NSLocalizedString("ThisEventIsForSuperSponsorsOnly",
                                                                          comment: "Message shown in the event detail view when viewing an event that's only available for attendees who are super sponsors")

    public static let selectAnOption = NSLocalizedString("SelectAnOption",
                                                         comment: "Title for action sheets present on top of maps when multiple options available for a tapped target")

    public static let artShow = NSLocalizedString("ArtShow",
                                                  comment: "Message shown in the event detail view when viewing an event that's part of the art show")

    public static let kageGuestMessage = NSLocalizedString("KageGuestMessage",
                                                           comment: "Message shown in the event detail view when viewing an event that Kage is hosting")

    public static let dealersDen = NSLocalizedString("DealersDen",
                                                     comment: "Message shown in the event detail view when viewing an event that takes place in the dealers den")

    public static let mainStageEvent = NSLocalizedString("MainStageEvent",
                                                         comment: "Message shown in the event detail view when viewing an event that takes place in the main stage")

    public static let photoshoot = NSLocalizedString("Photoshoot",
                                                     comment: "Message shown in the event detail view when viewing an event that is part of a photoshoot")

    public static let restrictEventsToDateFormat = NSLocalizedString("RestrictEventsToDateFormat",
                                                                     comment: "Format string used to build up an accessibility hint for the days button in the Schedule tab")

    public static let invalidAnnouncementAlertTitle = NSLocalizedString("InvalidAnnouncementAlertTitle",
                                                                        comment: "Title for the alert shown when trying to open an announcenent that has been deleted")

    public static let invalidAnnouncementAlertMessage = NSLocalizedString("InvalidAnnouncementAlertMessage",
                                                                          comment: "Message for the alert shown when trying to open an announcenent that has been deleted")

    private struct Formatters {
        static var numbers = NumberFormatter()
    }

    internal static func welcomePrompt(for user: User) -> String {
        return localizedStringWithFormat(authenticatedUserLoginPromptFormat,
                                         user.username,
                                         Formatters.numbers.string(from: NSNumber(value: user.registrationNumber))!)
    }

    internal static func welcomeDescription(messageCount: Int) -> String {
        return localizedStringWithFormat(authentiatedUserLoginDescriptionFormat, messageCount)
    }

    static func daysUntilConventionMessage(days: Int) -> String {
        return localizedStringWithFormat(daysRemainingFormat, days)
    }

    static func formattedOnlyPresentOnDaysString(_ days: [String]) -> String {
        return localizedStringWithFormat(onlyPresentOnSpecificDaysFormat, days.joined(separator: ", "))
    }

    static func eventReminderBody(timeString: String, roomName: String) -> String {
        return localizedStringWithFormat(eventReminderBodyFormat, timeString, roomName)
    }

    static func restrictEventsAccessibilityHint(date: String) -> String {
        return localizedStringWithFormat(restrictEventsToDateFormat, date)
    }

}
