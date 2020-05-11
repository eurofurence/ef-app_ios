import Eurofurence

extension NewsViewModelValue: Equatable {

    public static func == (lhs: NewsViewModelValue, rhs: NewsViewModelValue) -> Bool {
        switch (lhs, rhs) {
        case (.messages, .messages):
            return true

        case (.announcement(let l), .announcement(let r)):
            return l == r

        case (.event(let l), .event(let r)):
            return l.identifier == r.identifier

        case (.allAnnouncements, .allAnnouncements):
            return true

        default:
            return false
        }
    }

}
