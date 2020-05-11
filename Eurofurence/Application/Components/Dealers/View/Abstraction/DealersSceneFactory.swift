import UIKit.UIViewController

public protocol DealersSceneFactory {

    func makeDealersScene() -> UIViewController & DealersScene

}
