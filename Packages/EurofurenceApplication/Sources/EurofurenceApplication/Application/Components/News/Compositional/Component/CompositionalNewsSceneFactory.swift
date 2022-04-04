import UIKit

public protocol CompositionalNewsSceneFactory {
    
    func makeCompositionalNewsScene() -> UIViewController & CompositionalNewsScene
    
}
