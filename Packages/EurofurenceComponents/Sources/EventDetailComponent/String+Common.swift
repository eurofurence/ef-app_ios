import Foundation

extension String {
    
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
    
}
