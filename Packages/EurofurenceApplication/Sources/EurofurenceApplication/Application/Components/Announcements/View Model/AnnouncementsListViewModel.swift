import EurofurenceModel
import Foundation

public protocol AnnouncementsListViewModel {

    var numberOfAnnouncements: Int { get }

    func setDelegate(_ delegate: AnnouncementsListViewModelDelegate)
    func announcementViewModel(at index: Int) -> AnnouncementItemViewModel
    func identifierForAnnouncement(at index: Int) -> AnnouncementIdentifier

}

public struct AnnouncementItemViewModel: Hashable {

    public var title: String
    public var detail: NSAttributedString
    public var receivedDateTime: String
    public var isRead: Bool
    
    public init(
        title: String,
        detail: NSAttributedString,
        receivedDateTime: String,
        isRead: Bool
    ) {
        self.title = title
        self.detail = detail
        self.receivedDateTime = receivedDateTime
        self.isRead = isRead
    }

}

public protocol AnnouncementsListViewModelDelegate {

    func announcementsViewModelDidChangeAnnouncements()

}
