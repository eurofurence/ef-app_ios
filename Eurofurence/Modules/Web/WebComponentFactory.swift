import Foundation
import UIKit.UIViewController

public protocol WebComponentFactory {

    func makeWebModule(for url: URL) -> UIViewController

}
