//
//  MapDetailViewController.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 27/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import UIKit

class MapDetailViewController: UIViewController, UIScrollViewDelegate, MapDetailScene {

    // MARK: Properties

    @IBOutlet weak var scrollView: UIScrollView!
    private var imageView: UIImageView?

    // MARK: Overrides

    override func viewDidLoad() {
        super.viewDidLoad()

        scrollView.delegate = self
        delegate?.mapDetailSceneDidLoad()
    }

    // MARK: Actions

    @IBAction func scrollViewTapped(_ sender: UIGestureRecognizer) {
        let tapLocation = sender.location(in: imageView)
        let position = MapCoordinate(x: Float(tapLocation.x), y: Float(tapLocation.y))
        delegate?.mapDetailSceneDidTapMap(at: position)
    }

    // MARK: UIScrollViewDelegate

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }

    // MARK: MapDetailScene

    private var delegate: MapDetailSceneDelegate?
    func setDelegate(_ delegate: MapDetailSceneDelegate) {
        self.delegate = delegate
    }

    func setMapImagePNGData(_ data: Data) {
        let image = UIImage(data: data)
        let imageView = UIImageView(image: image)
        self.imageView = imageView
        scrollView.addSubview(imageView)

        if let image = image {
            scrollView.contentSize = image.size
        }
    }

    func setMapTitle(_ title: String) {
        navigationItem.title = title
    }

    func focusMapPosition(_ position: MapCoordinate) {

    }

    func show(contextualContent: MapInformationContextualContent) {

    }

}
