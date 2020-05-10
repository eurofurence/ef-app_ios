import Foundation

protocol ScheduleViewModelFactory {

    func makeViewModel(completionHandler: @escaping (ScheduleViewModel) -> Void)
    func makeSearchViewModel(completionHandler: @escaping (ScheduleSearchViewModel) -> Void)

}
