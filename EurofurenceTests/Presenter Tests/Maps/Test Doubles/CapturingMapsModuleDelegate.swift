@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import Foundation

class CapturingMapsModuleDelegate: MapsModuleDelegate {

    private(set) var capturedMapIdentifierToPresent: MapIdentifier?
    func mapsModuleDidSelectMap(identifier: MapIdentifier) {
        capturedMapIdentifierToPresent = identifier
    }

}
