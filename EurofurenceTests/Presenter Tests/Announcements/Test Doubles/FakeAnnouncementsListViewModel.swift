@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import Foundation

class FakeAnnouncementsListViewModel: AnnouncementsListViewModel {

    private(set) var announcements: [AnnouncementComponentViewModel]

    init(announcements: [AnnouncementComponentViewModel] = .random) {
        self.announcements = announcements
    }

    var numberOfAnnouncements: Int {
        return announcements.count
    }

    fileprivate var delegate: AnnouncementsListViewModelDelegate?
    func setDelegate(_ delegate: AnnouncementsListViewModelDelegate) {
        self.delegate = delegate
    }

    func announcementViewModel(at index: Int) -> AnnouncementComponentViewModel {
        return announcements[index]
    }

    func identifierForAnnouncement(at index: Int) -> AnnouncementIdentifier {
        return AnnouncementIdentifier("\(index)")
    }

}

extension FakeAnnouncementsListViewModel {

    func simulateUpdatedAnnouncements(_ newAnnouncements: [AnnouncementComponentViewModel]) {
        self.announcements = newAnnouncements
        delegate?.announcementsViewModelDidChangeAnnouncements()
    }

}
