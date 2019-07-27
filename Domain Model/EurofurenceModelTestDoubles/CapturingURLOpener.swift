import EurofurenceModel
import Foundation.NSURL

public class CapturingURLOpener: URLOpener {

    public init() {

    }

    public private(set) var capturedURLToOpen: URL?
    public func open(_ url: URL) {
        capturedURLToOpen = url
    }

}
