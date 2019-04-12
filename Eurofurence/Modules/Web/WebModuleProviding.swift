import Foundation
import UIKit.UIViewController

protocol WebModuleProviding {

    func makeWebModule(for url: URL) -> UIViewController

}
