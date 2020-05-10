import EurofurenceModel

protocol AnnouncementDetailViewModelFactory {

    func makeViewModel(
        for announcement: AnnouncementIdentifier,
        completionHandler: @escaping (AnnouncementDetailViewModel) -> Void
    )

}
