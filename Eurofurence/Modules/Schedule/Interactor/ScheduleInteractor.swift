import Foundation

protocol ScheduleInteractor {

    func makeViewModel(completionHandler: @escaping (ScheduleViewModel) -> Void)
    func makeSearchViewModel(completionHandler: @escaping (ScheduleSearchViewModel) -> Void)

}
