import UIKit

protocol TabModuleProviding {

    func makeTabModule(_ childModules: [UIViewController]) -> UITabBarController

}
