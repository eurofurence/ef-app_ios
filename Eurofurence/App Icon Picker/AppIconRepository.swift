import Foundation

public class AppIconRepository {
    
    private var appIconsFromPropertyList: [AppIcon]?
    
    public init() {
        
    }
    
    public func loadAvailableIcons() -> [AppIcon] {
        if let appIconsFromPropertyList = appIconsFromPropertyList {
            return appIconsFromPropertyList
        } else {
            return loadAndCacheAppIconsFromPropertyList()
        }
    }
    
    private func loadAndCacheAppIconsFromPropertyList() -> [AppIcon] {
        cacheAppIconsFromPropertyList()
        return appIconsFromPropertyList ?? []
    }
    
    private func cacheAppIconsFromPropertyList() {
        let bundle = Bundle(for: type(of: self))
        guard let propertyListURL = bundle.url(forResource: "AppIcons", withExtension: "plist") else {
            fatalError("AppIcons plist missing from bundle!")
        }
        
        do {
            let propertyListData = try Data(contentsOf: propertyListURL)
            let decoder = PropertyListDecoder()
            let propertyListIcons = try decoder.decode([PropertyListAppIconEntry].self, from: propertyListData)
            appIconsFromPropertyList = propertyListIcons.map(\.appIcon)
        } catch {
            print("Failed to load AppIcons property list. Error=\(error)")
        }
    }
    
    private struct PropertyListAppIconEntry: Decodable {
        
        var appIcon: AppIcon {
            let bundle = Bundle(for: AppIconRepository.self)
            let localizedDisplayName = bundle.localizedString(
                forKey: displayNameLocalizationKey,
                value: nil,
                table: "AppIconDisplayNames"
            )
            
            return AppIcon(displayName: localizedDisplayName, imageFileName: imageFileName)
        }
        
        private enum CodingKeys: String, CodingKey {
            case imageFileName = "EFAppIconImageFileName"
            case displayNameLocalizationKey = "EFAppIconDisplayNameLocalizedStringKey"
        }
        
        var imageFileName: String
        var displayNameLocalizationKey: String
        
    }
    
}
