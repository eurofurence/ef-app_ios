import EurofurenceModel
import Foundation

// swiftlint:disable line_length
public extension String {
    
    private static let tableName = "Strings"
    private static let tableBundle = Bundle.main
    
    static let ok = NSLocalizedString("ok",
                                      comment: "Affirmative action used by prompts to accept an action")
    
    static let cancel = NSLocalizedString("cancel",
                                          comment: "Negative action used by prompts to decline an action")
    
    static let tryAgain = NSLocalizedString("tryAgain",
                                            comment: "Used by prompts when an action fails, re-instigating the failed task")
    
    static let tutorialPushPermissionsRequestTitle = NSLocalizedString("tutorialPushPermissionsRequestTitle",
                                                                       comment: "Title used in the tutorial when asking for push permissions from the user")
    
    static let tutorialPushPermissionsRequestDescription = NSLocalizedString("tutorialPushPermissionsRequestDescription",
                                                                             comment: "Description used in the tutorial when asking for push permissions from the user")
    
    static let tutorialAllowPushPermissions = NSLocalizedString("tutorialAllowPushPermissions",
                                                                comment: "Text used in the button where the user allows us to send them push notifications")
    
    static let tutorialDenyPushPermissions = NSLocalizedString("tutorialDenyPushPermissions",
                                                               comment: "Text used in the button where the user does not allow us to send them push notifications")
    
    static let tutorialInitialLoadTitle = NSLocalizedString("tutorialInitialLoadTitle",
                                                            comment: "Title used in the tutorial telling the user we need to perform the initial download before they can use the app")
    
    static let tutorialInitialLoadDescription = NSLocalizedString("tutorialInitialLoadDescription",
                                                                  comment: "Description used in the tutorial telling the user we need to perform the initial download before they can use the app")
    
    static let tutorialInitialLoadBeginDownload = NSLocalizedString("tutorialInitialLoadBeginDownload",
                                                                    comment: "Text used in the button where the user allows us to begin the initial download")
    
    static let cellularDownloadAlertTitle = NSLocalizedString("cellularDownloadAlertTitle",
                                                              comment: "Title for the prompt asking if the user wants to perform the initial download over cellular data")
    
    static let cellularDownloadAlertMessage = NSLocalizedString("cellularDownloadAlertMessage",
                                                                comment: "Description for the prompt asking if the user wants to perform the initial download over cellular data")
    
    static let cellularDownloadAlertContinueOverCellularTitle = NSLocalizedString("cellularDownloadAlertContinueOverCellularTitle",
                                                                                  comment: "Confirmation action allowing the initial download to begin over cellular")
    
    static let noNetworkAlertTitle = NSLocalizedString("noNetworkAlertTitle",
                                                       comment: "Title for the alert when the initial sync fails due to no network")
    
    static let noNetworkAlertMessage = NSLocalizedString("noNetworkAlertMessage",
                                                         comment: "Alert body when the initial sync fails due to no network")
    
    static let downloadError = NSLocalizedString("downloadError",
                                                 comment: "Title for the alert when the download fails")
    
    static let preloadFailureMessage = NSLocalizedString("preloadFailureMessage",
                                                         comment: "Description for the alert when the download fails")
    
    static let news = NSLocalizedString("News", comment: "The title shown for the News view")
    static let yourEurofurence = NSLocalizedString("YourEurofurence",
                                                   comment: "Heading for the messages widget in the News tab")
    static let announcements = NSLocalizedString("Announcements",
                                                 comment: "Heading for the announcements shown to the user in the News tab")
    static let allAnnouncements = NSLocalizedString("AllAnnouncements",
                                                    comment: "Title for the component in the News view to show a list of all the announcements sent during the convention")
    static let daysUntilConvention = NSLocalizedString("DaysUntilConventionHeader",
                                                       comment: "Header shown above the widget describing how many days are left until the convention")
    static let daysRemainingFormat = NSLocalizedString("DaysUntilConvention",
                                                       comment: "Format strings substituted with the remaining number of days until the convention")
    static let upcomingEvents = NSLocalizedString("UpcomingEvents",
                                                  comment: "Header shown above section in the News view for events that start soon")
    static let runningEvents = NSLocalizedString("RunningEvents",
                                                 comment: "Header shown above section in the News view for events that are currently running")
    static let todaysFavouriteEvents = NSLocalizedString("TodaysFavouriteEvents",
                                                         comment: "Header shown above section in the News view for events that the user has added to their favourites that are taking place today")
    static let now = NSLocalizedString("Now",
                                       comment: "Shown in place of the event start time when the event is running now")
    
    static let anonymousUserLoginPrompt = NSLocalizedString("anonymousUserLoginPrompt",
                                                            comment: "Tells user to login for additional features")
    
    static let anonymousUserLoginDescription = NSLocalizedString("anonymousUserLoginDescription",
                                                                 comment: "Additional information for logged out users")
    
    static let authenticatedUserLoginPromptFormat = NSLocalizedString("authenticatedUserLoginPromptFormat",
                                                                      comment: "Prompt displayed for logged in users, showing their username and registration number")
    
    static let authentiatedUserLoginDescriptionFormat = NSLocalizedString("authentiatedUserLoginDescriptionFormat",
                                                                          comment: "Prompt displayed to logged in users telling them how many unread messages they have")
    
    static let login = NSLocalizedString("login",
                                         comment: "Title displayed on the view asking the user to input their login details")
    
    static let loggingIn = NSLocalizedString("loggingIn",
                                             comment: "Title for the alert displayed as we're logging the user in")
    
    static let loggingInDetail = NSLocalizedString("loggingInDetail",
                                                   comment: "Description for the alert displayed as we're logging the user in")
    
    static let loginError = NSLocalizedString("loginError",
                                              comment: "Title for the alert displayed when we're unable to log the user in")
    
    static let loginErrorDetail = NSLocalizedString("loginErrorDetail",
                                                    comment: "Description for the alert displayed when we're unable to log the user in")
    
    static let logout = NSLocalizedString("Logout",
                                          comment: "Title for the bar button in the Messages tab allowing the user to log out of the app")
    
    static let loggingOut = NSLocalizedString("LoggingOut",
                                              comment: "Title for the alert shown when the user has requested to be logged out")
    
    static let loggingOutAlertDetail = NSLocalizedString("LoggingOutAlertDetail",
                                                         comment: "Message for the alert shown when the user has requested to be logged out")
    
    static let logoutFailed = NSLocalizedString("LogoutFailed",
                                                comment: "Title for the alert shown when a user has requested to be logged out, but the app encountered an error")
    static let logoutFailedAlertDetail = NSLocalizedString("LogoutFailedAlertDetail",
                                                           comment: "Message for the alert shown when a user has requested to be logged out, but the app encountered an error")
    
    static let messages = NSLocalizedString("Messages",
                                            comment: "Title for the view that displays the user's private messages")
    
    static let schedule = NSLocalizedString("Schedule",
                                            comment: "Title for the view that shows the convention schedule")
    
    static let dealers = NSLocalizedString("Dealers",
                                           comment: "Title for the view that shows the dealers listed in the dealers den during the convention")
    
    static let conventionInformation = NSLocalizedString("ConventionInformation",
                                                         comment: "Title for the view showing all the categorised convention information")
    
    static let information = NSLocalizedString("Information",
                                               comment: "Tab bar item title for the view showing all the categoried convention information")
    
    static let announcement = NSLocalizedString("Announcement",
                                                comment: "Title for the view showing detailed information for an announcement")
    
    static let favourite = NSLocalizedString("Favourite",
                                             comment: "Title for the button used to add an event to the user's favourites")
    
    static let unfavourite = NSLocalizedString("Unfavourite",
                                               comment: "Title for the button used to remove an event from the user's favourites")
    
    static let locationAndAvailability = NSLocalizedString("LocationAndAvailability",
                                                           comment: "Heading for component in the dealer detail view explaining their location, convention availability and their AD status")
    static let locatedWithinAfterDarkDen = NSLocalizedString("LocatedWithinAfterDarkDen",
                                                             comment: "Short sentence describing that the dealer is located within the after-dark dealers den")
    
    static let onlyPresentOnSpecificDaysFormat = NSLocalizedString("OnlyPresentOnSpecificDaysFormat",
                                                                   comment: "Text displayed with the days during the convention a dealer is present for, e.g. 'Thursday'")
    
    static let aboutTheArtist = NSLocalizedString("AboutTheArtist",
                                                  comment: "Title for section in the Dealer Details screen showing the description provided by the artist")
    static let aboutTheArtistPlaceholder = NSLocalizedString("AboutTheArtistPlaceholder",
                                                             comment: "Placeholder text displayed in the Dealer Details screen when the artist did not provide a custom description about themselves")
    static let aboutTheArt = NSLocalizedString("AboutTheArt",
                                               comment: "Title for section in the Dealer Details screen showing the sample art provided by the dealer")
    
    static let collect = NSLocalizedString("Collect",
                                           comment: "Short title for the Collect-them-All screen shown in the tab bar")
    
    static let collectThemAll = NSLocalizedString("CollectThemAll",
                                                  comment: "Title shown at the top of the Collect-them-All screen")
    
    static let maps = NSLocalizedString("Maps",
                                        comment: "Title for the view containing the list of available convention maps")
    
    static let downloadingLatestData = NSLocalizedString("DownloadingLatestData",
                                                         comment: "Placeholder string displayed on the preload page to indicate to the user the app is updating")
    
    static let allEvents = NSLocalizedString("AllEvents",
                                             comment: "Title for the button used under the events search bar to search through all events")
    
    static let favourites = NSLocalizedString("Favourites",
                                              comment: "Title for the button used under the events search bar to search through only the user's favourites")
    
    static let thisEventIsForSponsorsOnly = NSLocalizedString("ThisEventIsForSponsorsOnly",
                                                              comment: "Message shown in the event detail view when viewing an event that's only available for attendees who are sponsors")
    
    static let thisEventIsForSuperSponsorsOnly = NSLocalizedString("ThisEventIsForSuperSponsorsOnly",
                                                                   comment: "Message shown in the event detail view when viewing an event that's only available for attendees who are super sponsors")
    
    static let selectAnOption = NSLocalizedString("SelectAnOption",
                                                  comment: "Title for action sheets present on top of maps when multiple options available for a tapped target")
    
    static let artShow = NSLocalizedString("ArtShow",
                                           comment: "Message shown in the event detail view when viewing an event that's part of the art show")
    
    static let kageGuestMessage = NSLocalizedString("KageGuestMessage",
                                                    comment: "Message shown in the event detail view when viewing an event that Kage is hosting")
    
    static let dealersDen = NSLocalizedString("DealersDen",
                                              comment: "Message shown in the event detail view when viewing an event that takes place in the dealers den")
    
    static let mainStageEvent = NSLocalizedString("MainStageEvent",
                                                  comment: "Message shown in the event detail view when viewing an event that takes place in the main stage")
    
    static let photoshoot = NSLocalizedString("Photoshoot",
                                              comment: "Message shown in the event detail view when viewing an event that is part of a photoshoot")
    
    static let restrictEventsToDateFormat = NSLocalizedString("RestrictEventsToDateFormat",
                                                              comment: "Format string used to build up an accessibility hint for the days button in the Schedule tab")
    
    static let invalidAnnouncementAlertTitle = NSLocalizedString("InvalidAnnouncementAlertTitle",
                                                                 comment: "Title for the alert shown when trying to open an announcenent that has been deleted")
    
    static let invalidAnnouncementAlertMessage = NSLocalizedString("InvalidAnnouncementAlertMessage",
                                                                   comment: "Message for the alert shown when trying to open an announcenent that has been deleted")
    
    static let eventFeedbackDayAndTimeFormat = NSLocalizedString("EventFeedbackDayAndTime",
                                                                 comment: "Format string used to show when an event occurs, like 'Sunday from 18:00 to 00:00'")
    
    static let eventHostedByFormat = NSLocalizedString("EventHostedBy",
                                                       comment: "Format string used to describe who is hosting an event, in the form 'Hosted by Stripe'")
    
    static let leaveFeedback = NSLocalizedString("LeaveFeedback",
                                                 comment: "Title for the command shown in the event detail scene for leaving feedback for an event")
    
    static let feedbackErrorTitle = NSLocalizedString("FeedbackErrorTitle",
                                                      comment: "Title for the alert displayed when attempting to leave feedback for an event fails")
    
    static let feedbackErrorMessage = NSLocalizedString("FeedbackErrorMessage",
                                                        comment: "Message for the alert displayed when attempting to leave feedback for an event fails")
    
    static let confirmDiscardEventFeedbackTitle = NSLocalizedString("ConfirmDiscardEventFeedbackTitle",
                                                                    comment: "Title for the alert presented to the user when confirming they want to discard any entered event feedback")
    
    static let discard = NSLocalizedString("Discard",
                                           comment: "Text used to describe actions related to user input that will cause their input to be discarded")
    
    private struct Formatters {
        static var numbers = NumberFormatter()
    }
    
    internal static func welcomePrompt(for user: User) -> String {
        guard let numbersString = Formatters.numbers.string(from: NSNumber(value: user.registrationNumber)) else { fatalError("Unable to format \(user.registrationNumber) into string") }
        
        return localizedStringWithFormat(authenticatedUserLoginPromptFormat,
                                         user.username,
                                         numbersString)
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
    
    static func restrictEventsAccessibilityHint(date: String) -> String {
        return localizedStringWithFormat(restrictEventsToDateFormat, date)
    }
    
    private static let eventReminderBodyFormat = NSLocalizedString("EventReminderBodyFormat",
                                                                   comment: "Format string used for event reminder notifications to tell the user when and where an upcoming event is taking place")
    
    static func eventReminderBody(timeString: String, roomName: String) -> String {
        return String.localizedStringWithFormat(eventReminderBodyFormat, timeString, roomName)
    }
    
}
