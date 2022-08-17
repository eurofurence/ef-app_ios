import RouterCore

public struct SettingsRouteable: Routeable {
    
    public static func == (lhs: SettingsRouteable, rhs: SettingsRouteable) -> Bool {
        type(of: lhs.sender) == type(of: rhs.sender)
    }
    
    public let sender: Any
    
    public init(sender: Any) {
        self.sender = sender
    }
    
}
