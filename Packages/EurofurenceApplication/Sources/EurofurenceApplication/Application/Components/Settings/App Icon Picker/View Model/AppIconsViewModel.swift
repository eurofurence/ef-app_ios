import Combine

public protocol AppIconsViewModel: ObservableObject {
    
    associatedtype Icon: AppIconViewModel
    
    var icons: [Icon] { get }
    
}
