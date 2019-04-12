@testable import Eurofurence
import EurofurenceModel
import Foundation.NSIndexPath

class AnnouncementsViewModel: NewsViewModel {

    var announcements: [[AnnouncementComponentViewModel]]

    convenience init() {
        let announcements = (0...Int.random(upperLimit: 5) + 1).map { (_) -> [AnnouncementComponentViewModel] in
            return [AnnouncementComponentViewModel].random
        }

        self.init(announcements: announcements)
    }

    init(announcements: [[AnnouncementComponentViewModel]]) {
        self.announcements = announcements
    }

    var numberOfComponents: Int {
        return announcements.count
    }

    func numberOfItemsInComponent(at index: Int) -> Int {
        return announcements[index].count
    }

    func titleForComponent(at index: Int) -> String {
        return "Announcements"
    }

    func describeComponent(at indexPath: IndexPath, to visitor: NewsViewModelVisitor) {
        let announcement = announcements[indexPath.section][indexPath.row]
        visitor.visit(announcement)
    }

    private var models = [IndexPath: NewsViewModelValue]()
    func fetchModelValue(at indexPath: IndexPath, completionHandler: @escaping (NewsViewModelValue) -> Void) {
        if let model = models[indexPath] {
            completionHandler(model)
        }
    }

    func stub(_ model: NewsViewModelValue, at indexPath: IndexPath) {
        models[indexPath] = model
    }

}
