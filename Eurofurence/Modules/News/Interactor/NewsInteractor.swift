protocol NewsInteractor {

    func subscribeViewModelUpdates(_ delegate: NewsInteractorDelegate)
    func refresh()

}

protocol NewsInteractorDelegate {

    func viewModelDidUpdate(_ viewModel: NewsViewModel)
    func refreshDidBegin()
    func refreshDidFinish()

}
