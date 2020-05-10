import Foundation

protocol MapsViewModelFactory {

    func makeMapsViewModel(completionHandler: @escaping (MapsViewModel) -> Void)

}
