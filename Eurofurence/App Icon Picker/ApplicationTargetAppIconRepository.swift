import EurofurenceApplication
import Foundation

public class ApplicationTargetAppIconRepository: AppIconRepository {
    
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
            let bundle = Bundle(for: ApplicationTargetAppIconRepository.self)
            let localizedDisplayName = bundle.localizedString(
                forKey: displayNameLocalizationKey,
                value: nil,
                table: "AppIconDisplayNames"
            )
            
            let alternateIconName: String? = self.alternateIconName.isEmpty ? nil : self.alternateIconName
            
            return AppIcon(
                displayName: localizedDisplayName,
                imageFileName: imageFileName,
                alternateIconName: alternateIconName
            )
        }
        
        private enum CodingKeys: String, CodingKey {
            case imageFileName = "EFAppIconImageFileName"
            case displayNameLocalizationKey = "EFAppIconDisplayNameLocalizedStringKey"
            case alternateIconName = "EFAppIconAlternateIconName"
        }
        
        var imageFileName: String
        var displayNameLocalizationKey: String
        var alternateIconName: String
        
    }
    
}
