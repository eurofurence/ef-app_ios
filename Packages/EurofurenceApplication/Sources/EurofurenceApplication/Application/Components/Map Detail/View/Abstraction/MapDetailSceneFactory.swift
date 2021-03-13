import UIKit

public protocol MapDetailSceneFactory {

    func makeMapDetailScene() -> UIViewController & MapDetailScene

}
