@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import Foundation

struct StubAnnouncementDetailInteractor: AnnouncementDetailInteractor {

    let viewModel: AnnouncementViewModel
    private var identifier: AnnouncementIdentifier

    init(viewModel: AnnouncementViewModel = .random, for identifier: AnnouncementIdentifier = .random) {
        self.viewModel = viewModel
        self.identifier = identifier
    }

    func makeViewModel(for announcement: AnnouncementIdentifier, completionHandler: @escaping (AnnouncementViewModel) -> Void) {
        guard identifier == announcement else { return }
        completionHandler(viewModel)
    }

}
