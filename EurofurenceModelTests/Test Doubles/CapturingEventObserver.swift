import EurofurenceModel

class CapturingEventObserver: EventObserver {

    enum FavouriteState {
        case unset
        case favourite
        case notFavourite
    }

    private(set) var eventFavouriteState: FavouriteState = .unset
    func eventDidBecomeFavourite(_ event: Event) {
        eventFavouriteState = .favourite
    }

    func eventDidBecomeUnfavourite(_ event: Event) {
        eventFavouriteState = .notFavourite
    }

}
