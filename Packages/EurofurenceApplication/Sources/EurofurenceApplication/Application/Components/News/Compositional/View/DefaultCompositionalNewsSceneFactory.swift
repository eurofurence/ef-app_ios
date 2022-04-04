import UIKit

struct DefaultCompositionalNewsSceneFactory: CompositionalNewsSceneFactory {
    
    func makeCompositionalNewsScene() -> UIViewController & CompositionalNewsScene {
        CompositionalNewsViewController()
    }
    
}
