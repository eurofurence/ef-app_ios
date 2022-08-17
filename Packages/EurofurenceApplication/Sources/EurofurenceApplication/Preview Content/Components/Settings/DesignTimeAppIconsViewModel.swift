import Combine

class DesignTimeAppIconsViewModel: AppIconsViewModel {
    
    typealias Icon = DesignTimeAppIconViewModel
    
    @Published var icons: [DesignTimeAppIconViewModel]
    
    init(icons: [DesignTimeAppIconViewModel]) {
        self.icons = icons
    }
    
}

extension DesignTimeAppIconsViewModel {
    
    static var sample: DesignTimeAppIconsViewModel {
        DesignTimeAppIconsViewModel(icons: [.classic, .highSeas])
    }
    
}
