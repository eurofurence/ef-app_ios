import Foundation

public protocol MapsService {
    
    func add(_ observer: MapsObserver)
    func fetchMap(for identifier: MapIdentifier) -> Map?

}

public protocol MapsObserver {

    func mapsServiceDidChangeMaps(_ maps: [Map])

}
