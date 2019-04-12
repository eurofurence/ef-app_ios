import UIKit

protocol PreloadModuleProviding {

    func makePreloadModule(_ delegate: PreloadModuleDelegate) -> UIViewController

}
