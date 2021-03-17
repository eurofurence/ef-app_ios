import EurofurenceApplication
import EurofurenceModel
import Foundation
import XCTEurofurenceModel

class CapturingMapsComponentDelegate: MapsComponentDelegate {

    private(set) var capturedMapIdentifierToPresent: MapIdentifier?
    func mapsComponentDidSelectMap(identifier: MapIdentifier) {
        capturedMapIdentifierToPresent = identifier
    }

}
