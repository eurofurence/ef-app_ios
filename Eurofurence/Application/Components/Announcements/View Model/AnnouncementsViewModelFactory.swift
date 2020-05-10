import Foundation

protocol AnnouncementsViewModelFactory {

    func makeViewModel(completionHandler: @escaping (AnnouncementsListViewModel) -> Void)

}
