import EurofurenceModel

protocol AnnouncementDetailInteractor {

    func makeViewModel(for announcement: AnnouncementIdentifier, completionHandler: @escaping (AnnouncementViewModel) -> Void)

}
