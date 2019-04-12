import EurofurenceModel
import Foundation

protocol MapDetailInteractor {

    func makeViewModelForMap(identifier: MapIdentifier, completionHandler: @escaping (MapDetailViewModel) -> Void)

}
