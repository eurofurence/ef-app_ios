import Foundation

public struct ConferenceDayCharacteristics: Equatable, Identifyable {

    public var identifier: String
    
    public var date: Date

    public init(identifier: String, date: Date) {
        self.identifier = identifier
        self.date = date
    }

}
