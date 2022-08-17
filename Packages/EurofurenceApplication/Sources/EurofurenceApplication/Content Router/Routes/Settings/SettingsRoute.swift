import ComponentBase
import RouterCore
import UIKit

public struct SettingsRoute {
    
    private let modalWireframe: any ModalWireframe
    private let settingsComponentFactory: any SettingsComponentFactory
    
    public init(modalWireframe: any ModalWireframe, settingsComponentFactory: any SettingsComponentFactory) {
        self.modalWireframe = modalWireframe
        self.settingsComponentFactory = settingsComponentFactory
    }
    
}

// MARK: - SettingsRoute + Route

extension SettingsRoute: Route {
    
    public typealias Parameter = SettingsRouteable
    
    public func route(_ parameter: Parameter) {
        let viewController = settingsComponentFactory.makeSettingsModule()
        
        if let barButtonItem = parameter.sender as? UIBarButtonItem {
            viewController.modalPresentationStyle = .popover
            viewController.popoverPresentationController?.barButtonItem = barButtonItem
        }
        
        modalWireframe.presentModalContentController(viewController)
    }
    
}
