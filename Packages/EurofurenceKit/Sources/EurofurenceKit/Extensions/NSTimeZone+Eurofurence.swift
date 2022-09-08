import Foundation

extension TimeZone {
    
    /// The `TimeZone` associated with the convention.
    public static var conventionTimeZone: TimeZone = {
        guard let timeZone = TimeZone(identifier: "Europe/Berlin") else {
            fatalError("Could not create a TimeZone for the Europe/Berlin region")
        }
        
        return timeZone
    }()
    
}
