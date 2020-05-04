import Foundation
import UIKit.UIViewController

public protocol WebModuleProviding {

    func makeWebModule(for url: URL) -> UIViewController

}
