import EurofurenceModel
import Foundation

public protocol EventDetailViewModelFactory {

    func makeViewModel(
        for event: EventIdentifier,
        completionHandler: @escaping (EventDetailViewModel) -> Void
    )

}
