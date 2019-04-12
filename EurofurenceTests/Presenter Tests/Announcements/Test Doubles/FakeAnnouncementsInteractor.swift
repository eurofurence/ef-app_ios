@testable import Eurofurence
import EurofurenceModel
import Foundation

struct FakeAnnouncementsInteractor: AnnouncementsInteractor {

    private let viewModel: AnnouncementsListViewModel

    init(viewModel: AnnouncementsListViewModel = FakeAnnouncementsListViewModel()) {
        self.viewModel = viewModel
    }

    func makeViewModel(completionHandler: @escaping (AnnouncementsListViewModel) -> Void) {
        completionHandler(viewModel)
    }

}
