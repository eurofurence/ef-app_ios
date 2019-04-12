import UIKit

protocol ModuleOrderingPolicy {

    func order(modules: [UIViewController]) -> [UIViewController]
    func saveOrder(_ modules: [UIViewController])

}
