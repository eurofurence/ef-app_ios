import EurofurenceModel
import Foundation
import UIKit

struct AppURLOpener: URLOpener {

    func open(_ url: URL) {
        UIApplication.shared.open(url)
    }

}
