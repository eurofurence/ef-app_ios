import EurofurenceModel
import Foundation

protocol EventDetailInteractor {

    func makeViewModel(for event: EventIdentifier, completionHandler: @escaping (EventDetailViewModel) -> Void)

}
