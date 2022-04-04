import UIKit

struct DefaultCompositionalNewsSceneFactory: CompositionalNewsSceneFactory {
    
    func makeCompositionalNewsScene() -> UIViewController & NewsWidgetManager {
        CompositionalNewsViewController()
    }
    
}
