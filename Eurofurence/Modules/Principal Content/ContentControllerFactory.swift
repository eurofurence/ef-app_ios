import UIKit

public protocol ContentControllerFactory {
    
    func makeContentController() -> UIViewController
    
}
