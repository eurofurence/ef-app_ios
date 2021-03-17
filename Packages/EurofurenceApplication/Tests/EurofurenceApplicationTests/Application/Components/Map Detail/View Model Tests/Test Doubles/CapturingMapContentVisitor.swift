import EurofurenceApplication
import EurofurenceModel
import Foundation
import XCTEurofurenceModel

class CapturingMapContentVisitor: MapContentVisitor {

    private(set) var capturedMapCoordinate: MapCoordinate?
    func visit(_ mapPosition: MapCoordinate) {
        capturedMapCoordinate = mapPosition
    }

    private(set) var capturedContextualContent: MapInformationContextualContent?
    func visit(_ content: MapInformationContextualContent) {
        capturedContextualContent = content
    }

    private(set) var capturedDealer: DealerIdentifier?
    func visit(_ dealer: DealerIdentifier) {
        capturedDealer = dealer
    }

    private(set) var capturedMapContents: MapContentOptionsViewModel?
    func visit(_ mapContents: MapContentOptionsViewModel) {
        capturedMapContents = mapContents
    }

}
