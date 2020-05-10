@testable import Eurofurence
import EurofurenceModel
import Foundation.NSURL
import UIKit.UIViewController

class StubWebComponentFactory: WebComponentFactory {

    var producedWebModules = [URL: UIViewController]()
    func makeWebModule(for url: URL) -> UIViewController {
        let module = UIViewController()
        producedWebModules[url] = module

        return module
    }

}
