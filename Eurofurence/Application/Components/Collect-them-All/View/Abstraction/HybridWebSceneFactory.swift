import UIKit

public protocol HybridWebSceneFactory {

    func makeHybridWebScene() -> UIViewController & HybridWebScene

}
