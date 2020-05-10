import EurofurenceModel
import Foundation

protocol AnnouncementsListViewModel {

    var numberOfAnnouncements: Int { get }

    func setDelegate(_ delegate: AnnouncementsListViewModelDelegate)
    func announcementViewModel(at index: Int) -> AnnouncementItemViewModel
    func identifierForAnnouncement(at index: Int) -> AnnouncementIdentifier

}

protocol AnnouncementsListViewModelDelegate {

    func announcementsViewModelDidChangeAnnouncements()

}
