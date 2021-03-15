import Foundation

public protocol AnnouncementsViewModelFactory {

    func makeViewModel(completionHandler: @escaping (AnnouncementsListViewModel) -> Void)

}
