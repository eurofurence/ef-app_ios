import EurofurenceModel
import Foundation

class CapturingMapsObserver: MapsObserver {

    private(set) var capturedMaps: [Map] = []
    func mapsServiceDidChangeMaps(_ maps: [Map]) {
        capturedMaps = maps
    }

}
