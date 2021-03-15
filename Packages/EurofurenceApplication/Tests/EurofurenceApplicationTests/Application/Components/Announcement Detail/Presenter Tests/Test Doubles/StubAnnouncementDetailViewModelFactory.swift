import EurofurenceApplication
import EurofurenceModel
import EurofurenceModelTestDoubles
import Foundation

struct StubAnnouncementDetailViewModelFactory: AnnouncementDetailViewModelFactory {

    let viewModel: AnnouncementDetailViewModel
    private var identifier: AnnouncementIdentifier

    init(viewModel: AnnouncementDetailViewModel = .random, for identifier: AnnouncementIdentifier = .random) {
        self.viewModel = viewModel
        self.identifier = identifier
    }

    func makeViewModel(
        for announcement: AnnouncementIdentifier, 
        completionHandler: @escaping (AnnouncementDetailViewModel) -> Void
    ) {
        guard identifier == announcement else { return }
        completionHandler(viewModel)
    }

}
