@testable import Eurofurence
import EurofurenceModel
import UIKit

class CapturingHybridWebScene: UIViewController, HybridWebScene {

    private(set) var delegate: HybridWebSceneDelegate?
    func setDelegate(_ delegate: HybridWebSceneDelegate) {
        self.delegate = delegate
    }

    private(set) var capturedShortTitle: String?
    func setSceneShortTitle(_ shortTitle: String) {
        capturedShortTitle = shortTitle
    }

    private(set) var capturedTitle: String?
    func setSceneTitle(_ title: String) {
        capturedTitle = title
    }

    private(set) var capturedURLRequest: URLRequest?
    func loadContents(of urlRequest: URLRequest) {
        capturedURLRequest = urlRequest
    }

}
