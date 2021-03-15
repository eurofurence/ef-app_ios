import Foundation

public protocol MapsViewModelFactory {

    func makeMapsViewModel(completionHandler: @escaping (MapsViewModel) -> Void)

}
