import EurofurenceApplication

class CapturingAnnouncementsListViewModelDelegate: AnnouncementsListViewModelDelegate {

    private(set) var toldAnnouncementsDidChange = false
    func announcementsViewModelDidChangeAnnouncements() {
        toldAnnouncementsDidChange = true
    }

}
