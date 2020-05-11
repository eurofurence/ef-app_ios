import EurofurenceModel
import Foundation

public class DefaultMapsViewModelFactory: MapsViewModelFactory, MapsObserver {

    private struct ViewModel: MapsViewModel {

        let maps: [Map]

        var numberOfMaps: Int {
            return maps.count
        }

        func mapViewModel(at index: Int) -> MapViewModel {
            return SingleViewModel(map: maps[index])
        }

        func identifierForMap(at index: Int) -> MapIdentifier? {
            return maps[index].identifier
        }

    }

    private struct SingleViewModel: MapViewModel {

        let map: Map

        init(map: Map) {
            self.map = map
        }

        var mapName: String {
            return map.location
        }

        func fetchMapPreviewPNGData(completionHandler: @escaping (Data) -> Void) {
            map.fetchImagePNGData(completionHandler: completionHandler)
        }

    }

    private var maps = [Map]()

    public init(mapsService: MapsService) {
        mapsService.add(self)
    }

    public func mapsServiceDidChangeMaps(_ maps: [Map]) {
        self.maps = maps
    }

    public func makeMapsViewModel(completionHandler: @escaping (MapsViewModel) -> Void) {
        completionHandler(ViewModel(maps: maps))
    }

}
