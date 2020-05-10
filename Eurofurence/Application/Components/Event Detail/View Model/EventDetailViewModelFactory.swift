import EurofurenceModel
import Foundation

protocol EventDetailViewModelFactory {

    func makeViewModel(
        for event: EventIdentifier,
        completionHandler: @escaping (EventDetailViewModel) -> Void
    )

}
