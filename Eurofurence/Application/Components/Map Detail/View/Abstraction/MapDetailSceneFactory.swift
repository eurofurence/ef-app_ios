import UIKit

protocol MapDetailSceneFactory {

    func makeMapDetailScene() -> UIViewController & MapDetailScene

}
