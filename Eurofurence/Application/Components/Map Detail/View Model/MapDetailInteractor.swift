import EurofurenceModel
import Foundation

protocol MapDetailViewModelFactory {

    func makeViewModelForMap(
        identifier: MapIdentifier,
        completionHandler: @escaping (MapDetailViewModel) -> Void
    )

}
