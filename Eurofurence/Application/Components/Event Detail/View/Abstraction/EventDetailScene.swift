public protocol EventDetailScene {

    func setDelegate(_ delegate: EventDetailSceneDelegate)
    func bind(numberOfComponents: Int, using binder: EventDetailBinder)

}

public protocol EventDetailSceneDelegate {

    func eventDetailSceneDidLoad()
    func eventDetailSceneDidAppear()
    func eventDetailSceneDidDisappear()

}
