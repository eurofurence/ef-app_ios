import Combine

class DesignTimeAppIconViewModel: AppIconViewModel {
    
    var id: some Hashable {
        imageName
    }
    
    @Published var imageName: String
    @Published var displayName: String
    @Published var isCurrentAppIcon: Bool
    
    init(
        imageName: String,
        displayName: String,
        isCurrentAppIcon: Bool
    ) {
        self.imageName = imageName
        self.displayName = displayName
        self.isCurrentAppIcon = isCurrentAppIcon
    }
    
    func selectAsAppIcon() {
        isCurrentAppIcon = true
    }
    
}

extension DesignTimeAppIconViewModel {
    
    static var classic: DesignTimeAppIconViewModel {
        DesignTimeAppIconViewModel(imageName: "Classic", displayName: "Classic", isCurrentAppIcon: false)
    }
    
    static var highSeas: DesignTimeAppIconViewModel {
        DesignTimeAppIconViewModel(imageName: "Pirate", displayName: "High Seas", isCurrentAppIcon: false)
    }
    
}
