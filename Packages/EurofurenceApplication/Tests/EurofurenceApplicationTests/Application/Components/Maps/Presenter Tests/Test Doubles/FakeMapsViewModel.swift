import EurofurenceApplication
import EurofurenceModel
import EurofurenceModelTestDoubles
import Foundation

class FakeMapsViewModel: MapsViewModel {

    var numberOfMaps: Int {
        return maps.count
    }

    var maps = [FakeMapViewModel(), FakeMapViewModel(), FakeMapViewModel()]

    func mapViewModel(at index: Int) -> MapViewModel {
        return maps[index]
    }

    func identifierForMap(at index: Int) -> MapIdentifier? {
        return MapIdentifier("\(index)")
    }

}

class FakeMapViewModel: MapViewModel {

    var mapName: String = .random
    var mapPreviewImagePNGData: Data = .random

    func fetchMapPreviewPNGData(completionHandler: @escaping (Data) -> Void) {
        completionHandler(mapPreviewImagePNGData)
    }

}
