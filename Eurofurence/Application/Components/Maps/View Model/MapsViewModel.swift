import EurofurenceModel
import Foundation

public protocol MapsViewModel {

    var numberOfMaps: Int { get }
    func mapViewModel(at index: Int) -> MapViewModel
    func identifierForMap(at index: Int) -> MapIdentifier?

}

public protocol MapViewModel {

    var mapName: String { get }
    func fetchMapPreviewPNGData(completionHandler: @escaping (Data) -> Void)

}
