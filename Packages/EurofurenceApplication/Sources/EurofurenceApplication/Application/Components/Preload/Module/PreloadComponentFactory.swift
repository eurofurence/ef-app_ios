import UIKit

public protocol PreloadComponentFactory {

    func makePreloadComponent(_ delegate: PreloadComponentDelegate) -> UIViewController

}
