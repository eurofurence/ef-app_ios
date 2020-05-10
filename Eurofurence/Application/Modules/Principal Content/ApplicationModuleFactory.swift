import UIKit

public protocol ApplicationModuleFactory {
    
    func makeApplicationModuleController() -> UIViewController
    
}
