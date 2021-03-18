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
    
}
