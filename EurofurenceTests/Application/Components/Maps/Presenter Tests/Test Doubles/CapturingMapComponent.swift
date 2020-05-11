import Eurofurence
import EurofurenceModel
import Foundation

class CapturingMapComponent: MapComponent {

    private(set) var boundMapName: String?
    func setMapName(_ mapName: String) {
        boundMapName = mapName
    }

    private(set) var boundMapPreviewData: Data?
    func setMapPreviewImagePNGData(_ data: Data) {
        boundMapPreviewData = data
    }

}
