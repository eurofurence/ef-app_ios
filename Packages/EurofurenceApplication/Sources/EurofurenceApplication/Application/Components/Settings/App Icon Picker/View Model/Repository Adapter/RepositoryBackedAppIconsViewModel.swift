import Combine

public class RepositoryBackedAppIconsViewModel<IconState>: AppIconsViewModel where IconState: ApplicationIconState {
    
    public init(repository: any AppIconRepository, applicationIconState: IconState) {
        let repositoryIcons = repository.loadAvailableIcons()
        icons = repositoryIcons.map({ IconViewModel(icon: $0, applicationIconState: applicationIconState) })
    }
    
    public typealias Icon = IconViewModel
    
    public private(set) var icons: [IconViewModel]
    
    public class IconViewModel: AppIconViewModel {
        
        private let icon: AppIcon
        private let applicationIconState: IconState
        private var subscriptions = Set<AnyCancellable>()
        
        init(icon: AppIcon, applicationIconState: IconState) {
            self.icon = icon
            self.applicationIconState = applicationIconState
            
            applicationIconState
                .alternateIconNamePublisher
                .map({ [icon] (alternateIconName) in icon.imageFileName == alternateIconName })
                .sink { [weak self] in self?.isCurrentAppIcon = $0 }
                .store(in: &subscriptions)
        }
        
        public var imageName: String {
            icon.imageFileName
        }
        
        public var displayName: String {
            icon.displayName
        }
        
        @Published public private(set) var isCurrentAppIcon: Bool = false
        
        public func selectAsAppIcon() {
            applicationIconState.updateApplicationIcon(alternateIconName: icon.imageFileName)
        }
        
    }
    
}
