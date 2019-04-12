protocol EventDetailScene {

    func setDelegate(_ delegate: EventDetailSceneDelegate)
    func bind(numberOfComponents: Int, using binder: EventDetailBinder)
    func showUnfavouriteEventButton()
    func showFavouriteEventButton()

}

protocol EventDetailSceneDelegate {

    func eventDetailSceneDidLoad()
    func eventDetailSceneDidTapFavouriteEventButton()
    func eventDetailSceneDidTapUnfavouriteEventButton()

}
