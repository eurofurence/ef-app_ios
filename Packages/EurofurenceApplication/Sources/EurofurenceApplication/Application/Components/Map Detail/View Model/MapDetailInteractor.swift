import EurofurenceModel
import Foundation

public protocol MapDetailViewModelFactory {

    func makeViewModelForMap(
        identifier: MapIdentifier,
        completionHandler: @escaping (MapDetailViewModel) -> Void
    )

}
