import UIKit

protocol HybridWebSceneFactory {

    func makeHybridWebScene() -> UIViewController & HybridWebScene

}
