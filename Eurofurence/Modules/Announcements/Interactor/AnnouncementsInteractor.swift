import Foundation

protocol AnnouncementsInteractor {

    func makeViewModel(completionHandler: @escaping (AnnouncementsListViewModel) -> Void)

}
