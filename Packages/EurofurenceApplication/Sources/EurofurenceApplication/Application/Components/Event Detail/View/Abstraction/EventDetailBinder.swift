import Foundation

public protocol EventDetailBinder {

    func bindComponent<T>(
        at indexPath: IndexPath,
        using componentFactory: T
    ) -> T.Component where T: EventDetailItemComponentFactory

}
