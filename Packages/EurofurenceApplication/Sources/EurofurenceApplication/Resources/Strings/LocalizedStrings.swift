import EurofurenceModel
import Foundation

// swiftlint:disable line_length
public extension String {
    
    private static let tableName = "Strings"
    private static let tableBundle = Bundle.module
    
    static let tutorialPushPermissionsRequestTitle = NSLocalizedString("tutorialPushPermissionsRequestTitle",
                                                                       bundle: .module,
                                                                       comment: "Title used in the tutorial when asking for push permissions from the user")
    
    static let tutorialPushPermissionsRequestDescription = NSLocalizedString("tutorialPushPermissionsRequestDescription",
                                                                             bundle: .module,
                                                                             comment: "Description used in the tutorial when asking for push permissions from the user")
    
    static let tutorialAllowPushPermissions = NSLocalizedString("tutorialAllowPushPermissions",
                                                                bundle: .module,
                                                                comment: "Text used in the button where the user allows us to send them push notifications")
    
    static let tutorialDenyPushPermissions = NSLocalizedString("tutorialDenyPushPermissions",
                                                               bundle: .module,
                                                               comment: "Text used in the button where the user does not allow us to send them push notifications")
    
    static let cellularDownloadAlertMessage = NSLocalizedString("cellularDownloadAlertMessage",
                                                                bundle: .module,
                                                                comment: "Description for the prompt asking if the user wants to perform the initial download over cellular data")
    
    static let news = NSLocalizedString("News", bundle: .module, comment: "The title shown for the News view")
    static let yourEurofurence = NSLocalizedString("YourEurofurence",
                                                   bundle: .module,
                                                   comment: "Heading for the messages widget in the News tab")
    static let announcements = NSLocalizedString("Announcements",
                                                 bundle: .module,
                                                 comment: "Heading for the announcements shown to the user in the News tab")
    static let allAnnouncements = NSLocalizedString("AllAnnouncements",
                                                    bundle: .module,
                                                    comment: "Title for the component in the News view to show a list of all the announcements sent during the convention")
    static let daysUntilConvention = NSLocalizedString("DaysUntilConventionHeader",
                                                       bundle: .module,
                                                       comment: "Header shown above the widget describing how many days are left until the convention")
    static let daysRemainingFormat = NSLocalizedString("DaysUntilConvention",
                                                       bundle: .module,
                                                       comment: "Format strings substituted with the remaining number of days until the convention")
    static let upcomingEvents = NSLocalizedString("UpcomingEvents",
                                                  bundle: .module,
                                                  comment: "Header shown above section in the News view for events that start soon")
    static let runningEvents = NSLocalizedString("RunningEvents",
                                                 bundle: .module,
                                                 comment: "Header shown above section in the News view for events that are currently running")
    static let todaysFavouriteEvents = NSLocalizedString("TodaysFavouriteEvents",
                                                         bundle: .module,
                                                         comment: "Header shown above section in the News view for events that the user has added to their favourites that are taking place today")
    static let now = NSLocalizedString("Now",
                                       bundle: .module,
                                       comment: "Shown in place of the event start time when the event is running now")
    
    static let anonymousUserLoginPrompt = NSLocalizedString("anonymousUserLoginPrompt",
                                                            bundle: .module,
                                                            comment: "Tells user to login for additional features")
    
    static let anonymousUserLoginDescription = NSLocalizedString("anonymousUserLoginDescription",
                                                                 bundle: .module,
                                                                 comment: "Additional information for logged out users")
    
    static let authenticatedUserLoginPromptFormat = NSLocalizedString("authenticatedUserLoginPromptFormat",
                                                                      bundle: .module,
                                                                      comment: "Prompt displayed for logged in users, showing their username and registration number")
    
    static let authentiatedUserLoginDescriptionFormat = NSLocalizedString("authentiatedUserLoginDescriptionFormat",
                                                                          bundle: .module,
                                                                          comment: "Prompt displayed to logged in users telling them how many unread messages they have")
    
    static let login = NSLocalizedString("login",
                                         bundle: .module,
                                         comment: "Title displayed on the view asking the user to input their login details")
    
    static let loggingIn = NSLocalizedString("loggingIn",
                                             bundle: .module,
                                             comment: "Title for the alert displayed as we're logging the user in")
    
    static let loggingInDetail = NSLocalizedString("loggingInDetail",
                                                   bundle: .module,
                                                   comment: "Description for the alert displayed as we're logging the user in")
    
    static let loginError = NSLocalizedString("loginError",
                                              bundle: .module,
                                              comment: "Title for the alert displayed when we're unable to log the user in")
    
    static let loginErrorDetail = NSLocalizedString("loginErrorDetail",
                                                    bundle: .module,
                                                    comment: "Description for the alert displayed when we're unable to log the user in")
    
    static let logout = NSLocalizedString("Logout",
                                          bundle: .module,
                                          comment: "Title for the bar button in the Messages tab allowing the user to log out of the app")
    
    static let loggingOut = NSLocalizedString("LoggingOut",
                                              bundle: .module,
                                              comment: "Title for the alert shown when the user has requested to be logged out")
    
    static let loggingOutAlertDetail = NSLocalizedString("LoggingOutAlertDetail",
                                                         bundle: .module,
                                                         comment: "Message for the alert shown when the user has requested to be logged out")
    
    static let logoutFailed = NSLocalizedString("LogoutFailed",
                                                bundle: .module,
                                                comment: "Title for the alert shown when a user has requested to be logged out, but the app encountered an error")
    static let logoutFailedAlertDetail = NSLocalizedString("LogoutFailedAlertDetail",
                                                           bundle: .module,
                                                           comment: "Message for the alert shown when a user has requested to be logged out, but the app encountered an error")
    
    static let messages = NSLocalizedString("Messages",
                                            bundle: .module,
                                            comment: "Title for the view that displays the user's private messages")
    
    static let announcement = NSLocalizedString("Announcement",
                                                bundle: .module,
                                                comment: "Title for the view showing detailed information for an announcement")
    
    static let collect = NSLocalizedString("Collect",
                                           bundle: .module,
                                           comment: "Short title for the Collect-them-All screen shown in the tab bar")
    
    static let collectThemAll = NSLocalizedString("CollectThemAll",
                                                  bundle: .module,
                                                  comment: "Title shown at the top of the Collect-them-All screen")
    
    static let maps = NSLocalizedString("Maps",
                                        bundle: .module,
                                        comment: "Title for the view containing the list of available convention maps")
    
    static let selectAnOption = NSLocalizedString("SelectAnOption",
                                                  bundle: .module,
                                                  comment: "Title for action sheets present on top of maps when multiple options available for a tapped target")
    
    static let invalidAnnouncementAlertTitle = NSLocalizedString("InvalidAnnouncementAlertTitle",
                                                                 bundle: .module,
                                                                 comment: "Title for the alert shown when trying to open an announcenent that has been deleted")
    
    static let invalidAnnouncementAlertMessage = NSLocalizedString("InvalidAnnouncementAlertMessage",
                                                                   bundle: .module,
                                                                   comment: "Message for the alert shown when trying to open an announcenent that has been deleted")
    
    static let services = NSLocalizedString("Services",
                                            bundle: .module,
                                            comment: "Tab bar title used for the companion app hybrid scene")
    
    static let additionalServices = NSLocalizedString("AdditionalServices",
                                                      bundle: .module,
                                                      comment: "Navigation title used for the compainion app hybrid scene")
    
    private struct Formatters {
        static var numbers = NumberFormatter()
    }
    
    static func welcomePrompt(for user: User) -> String {
        guard let numbersString = Formatters.numbers.string(from: NSNumber(value: user.registrationNumber)) else { fatalError("Unable to format \(user.registrationNumber) into string") }
        
        return localizedStringWithFormat(authenticatedUserLoginPromptFormat,
                                         user.username,
                                         numbersString)
    }
    
    static func welcomeDescription(messageCount: Int) -> String {
        return localizedStringWithFormat(authentiatedUserLoginDescriptionFormat, messageCount)
    }
    
    static func daysUntilConventionMessage(days: Int) -> String {
        return localizedStringWithFormat(daysRemainingFormat, days)
    }
    
    private static let eventReminderBodyFormat = NSLocalizedString("EventReminderBodyFormat",
                                                                   bundle: .module,
                                                                   comment: "Format string used for event reminder notifications to tell the user when and where an upcoming event is taking place")
    
    static func eventReminderBody(timeString: String, roomName: String) -> String {
        return String.localizedStringWithFormat(eventReminderBodyFormat, timeString, roomName)
    }
    
    static func viewDealer(named name: String) -> String {
        let format = NSLocalizedString("ViewDealerFormatString", bundle: .module, comment: "Format string used for handoff titles for dealers")
        return String.localizedStringWithFormat(format, name)
    }
    
}
