import Foundation

protocol EventDetailBinder {

    func bindComponent<T>(at indexPath: IndexPath, using componentFactory: T) -> T.Component where T: EventDetailComponentFactory

}
