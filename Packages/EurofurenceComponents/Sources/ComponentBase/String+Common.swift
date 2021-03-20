import Foundation

extension String {
    
    public static let ok = NSLocalizedString(
        "OK",
        bundle: .module,
        comment: "Affirmative action used by prompts to accept an action"
    )
    
    public static let cancel = NSLocalizedString(
        "Cancel",
        bundle: .module,
        comment: "Negative action used by prompts to decline an action"
    )
    
    public static let tryAgain = NSLocalizedString(
        "Try Again",
        bundle: .module,
        comment: "Used by prompts when an action fails, re-instigating the failed task"
    )
    
    public static let discard = NSLocalizedString(
        "Discard",
        bundle: .module,
        comment: "Text used to describe actions related to user input that will cause their input to be discarded"
    )
    
    public static let share = NSLocalizedString(
        "Share",
        bundle: .module,
        comment: "Title for buttons used for share actions (e.g. events)"
    )
    
    public static let favourite = NSLocalizedString(
        "Favourite",
        bundle: .module,
        comment: "Title for the button used to add an event to the user's favourites"
    )
    
    public static let unfavourite = NSLocalizedString(
        "Unfavourite",
        bundle: .module,
        comment: "Title for the button used to remove an event from the user's favourites"
    )
    
    public static let leaveFeedback = NSLocalizedString(
        "LeaveFeedback",
        bundle: .module,
        comment: "Title for commands used to leave feedback, e.g. events"
    )
    
}
