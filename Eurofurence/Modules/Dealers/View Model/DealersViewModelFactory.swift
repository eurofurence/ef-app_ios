import Foundation

protocol DealersViewModelFactory {

    func makeDealersViewModel(completionHandler: @escaping (DealersViewModel) -> Void)
    func makeDealersSearchViewModel(completionHandler: @escaping (DealersSearchViewModel) -> Void)
    func makeDealerCategoriesViewModel(completionHandler: @escaping (DealerCategoriesViewModel) -> Void)

}
