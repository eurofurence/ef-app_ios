import UIKit.UIViewController
import UIKit.UIWindow

struct AppWindowWireframe: WindowWireframe {

    static var shared: AppWindowWireframe = {
        let window = UIApplication.shared.delegate!.window!!
        return AppWindowWireframe(window: window)
    }()

    private let containerViewController: ContainerViewController

    public init(window: UIWindow) {
        containerViewController = ContainerViewController()
        window.rootViewController = containerViewController
    }

    func setRoot(_ viewController: UIViewController) {
        containerViewController.swapRoot(to: viewController)
    }
    
    private class ContainerViewController: UIViewController {
        
        private var currentRoot: UIViewController?
        
        override func viewDidLoad() {
            super.viewDidLoad()
            view.backgroundColor = .pantone330U
        }
        
        func swapRoot(to newRoot: UIViewController) {
            embedChild(newRoot)
            
            UIView.animate(withDuration: 0.25, animations: {
                newRoot.view.alpha = 1
                self.currentRoot?.view.alpha = 0
            }, completion: { (_) in
                self.unembedChild(self.currentRoot)
                self.currentRoot = newRoot
            })
        }
        
        private func embedChild(_ newRoot: UIViewController) {
            newRoot.willMove(toParent: self)
            newRoot.view.alpha = 0
            view.addSubview(newRoot.view)
            NSLayoutConstraint.activate([newRoot.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                                         newRoot.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                                         newRoot.view.topAnchor.constraint(equalTo: view.topAnchor),
                                         newRoot.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
                ])
            
            addChild(newRoot)
            newRoot.didMove(toParent: self)
        }
        
        private func unembedChild(_ oldRoot: UIViewController?) {
            oldRoot?.view.alpha = 0
            oldRoot?.willMove(toParent: nil)
            oldRoot?.view.removeFromSuperview()
            oldRoot?.removeFromParent()
            oldRoot?.didMove(toParent: nil)
        }
        
    }

}
