import Foundation

public protocol URLOpener {

    func canOpen(_ url: URL) -> Bool
    func open(_ url: URL)

}
