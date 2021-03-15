import EurofurenceModel
import Foundation

public protocol MapDetailViewModel {

    var mapImagePNGData: Data { get }
    var mapName: String { get }

    func showContentsAtPosition(x: Float, y: Float, describingTo visitor: MapContentVisitor)

}

public protocol MapContentVisitor {

    func visit(_ mapPosition: MapCoordinate)
    func visit(_ content: MapInformationContextualContent)
    func visit(_ dealer: DealerIdentifier)
    func visit(_ mapContents: MapContentOptionsViewModel)

}
