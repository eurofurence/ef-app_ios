import EurofurenceModel
import Foundation.NSURL
import UIKit.UIApplication

struct AppURLOpener: URLOpener {

    func canOpen(_ url: URL) -> Bool {
        return UIApplication.shared.canOpenURL(url)
    }

    func open(_ url: URL) {
        UIApplication.shared.open(url)
    }

}
