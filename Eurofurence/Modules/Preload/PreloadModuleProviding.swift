import UIKit

public protocol PreloadModuleProviding {

    func makePreloadModule(_ delegate: PreloadModuleDelegate) -> UIViewController

}
