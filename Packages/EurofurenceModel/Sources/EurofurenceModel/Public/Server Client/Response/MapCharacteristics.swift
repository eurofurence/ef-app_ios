import Foundation

// swiftlint:disable nesting
public struct MapCharacteristics: Equatable, Identifyable {

    public static func == (lhs: MapCharacteristics, rhs: MapCharacteristics) -> Bool {
        return lhs.identifier == rhs.identifier &&
               lhs.imageIdentifier == rhs.imageIdentifier &&
               lhs.mapDescription == rhs.mapDescription &&
               lhs.order == rhs.order &&
               lhs.entries.count == rhs.entries.count &&
               lhs.entries.contains(elementsFrom: rhs.entries)
    }

    public struct Entry: Equatable, Identifyable {

        public static func == (lhs: Entry, rhs: Entry) -> Bool {
            return lhs.identifier == rhs.identifier &&
                   lhs.x == rhs.x &&
                   lhs.y == rhs.y &&
                   lhs.tapRadius == rhs.tapRadius &&
                   lhs.links.count == rhs.links.count &&
                   lhs.links.contains(elementsFrom: rhs.links)
        }

        public struct Link: Equatable {

            public enum FragmentType: Int {
                case conferenceRoom
                case mapEntry
                case dealerDetail
            }

            public var type: FragmentType
            public var name: String?
            public var target: String

            public init(type: FragmentType, name: String?, target: String) {
                self.type = type
                self.name = name
                self.target = target
            }

        }

        public var identifier: String
        
        public var x: Int
        public var y: Int
        public var tapRadius: Int
        public var links: [Link]

        public init(identifier: String, x: Int, y: Int, tapRadius: Int, links: [Link]) {
            self.identifier = identifier
            self.x = x
            self.y = y
            self.tapRadius = tapRadius
            self.links = links
        }

    }

    public var identifier: String
    
    public var imageIdentifier: String
    public var mapDescription: String
    public var order: Int
    public var entries: [Entry]

    public init(identifier: String, imageIdentifier: String, mapDescription: String, order: Int, entries: [Entry]) {
        self.identifier = identifier
        self.imageIdentifier = imageIdentifier
        self.mapDescription = mapDescription
        self.order = order
        self.entries = entries
    }

}
