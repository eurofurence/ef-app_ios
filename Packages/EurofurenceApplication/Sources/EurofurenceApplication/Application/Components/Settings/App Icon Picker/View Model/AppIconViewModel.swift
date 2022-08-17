import Combine

public protocol AppIconViewModel: ObservableObject, Identifiable {
    
    var imageName: String { get }
    var displayName: String { get }
    var isCurrentAppIcon: Bool { get }
    
    func selectAsAppIcon()
    
}
