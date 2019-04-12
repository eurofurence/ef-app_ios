import UIKit

extension AppDelegate {

    func installDebugModule() {
        guard let window = window else { return }

        let complicatedGesture = UITapGestureRecognizer(target: self, action: #selector(showDebugMenu))
        complicatedGesture.numberOfTouchesRequired = 2
        complicatedGesture.numberOfTapsRequired = 5
        window.addGestureRecognizer(complicatedGesture)
    }

    @objc private func showDebugMenu(_ sender: UIGestureRecognizer) {
        let storyboard = UIStoryboard(name: "Debug", bundle: .main)
        guard let viewController = storyboard.instantiateInitialViewController() else { return }

        let host = UINavigationController(rootViewController: viewController)
        host.modalPresentationStyle = .formSheet
        window?.rootViewController?.present(host, animated: true)
    }

}
