//
//  MapViewController.swift
//  Eurofurence
//
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class MapViewController: UIViewController, UIScrollViewDelegate {
    static let imagePlaceholder = UIImage(named: "ef")
    static let ZOOM_STEPS = 3
    static let MAX_ZOOM_SCALE_FACTOR: CGFloat = 5.0
    static let MIN_ZOOM_SCALE_FACTOR: CGFloat = 1.0

    @IBOutlet weak var mapContainerView: UIScrollView!
    @IBOutlet weak var mapSwitchControl: UISegmentedControl!
    var burgerMenuItem: UIBarButtonItem!
    var mapIdToIndex: [String:Int] = [:]
    var mapViews: [UIImageView] = []
	// TODO: Should be weak references!
    var mapEntries: [[MapEntry]] = []
    var doubleTap: UITapGestureRecognizer!
    var singleTap: UITapGestureRecognizer!
    var currentMap: Int = 0
    weak var currentMapEntry: MapEntry?
    var currentMapEntryRadiusMultiplier = CGFloat(1.0)

	let dataContext: DataContextProtocol = try! ContextResolver.container.resolve()

    override func viewDidLoad() {
        super.viewDidLoad()

        // setup map container
        mapContainerView.delegate = self
        mapContainerView.backgroundColor = UIColor(red: 236/255.0, green: 240/255.0, blue: 241/255.0, alpha: 1.0)
        mapContainerView.minimumZoomScale = 1.0
        mapContainerView.maximumZoomScale = 5.0

        // add zoom on double tap
        doubleTap = UITapGestureRecognizer(target: self, action: #selector(MapViewController.zoom(_:)))
        doubleTap!.numberOfTapsRequired = 2
        mapContainerView!.addGestureRecognizer(doubleTap!)

        // add map entry on single tap
        singleTap = UITapGestureRecognizer(target: self, action: #selector(MapViewController.checkMapEntries(_:)))
        mapContainerView!.addGestureRecognizer(singleTap!)

        NotificationCenter.default.addObserver(self, selector: #selector(MapViewController.notificationRefresh(_:)), name:NSNotification.Name(rawValue: "reloadData"), object: nil)
        mapSwitchControl.removeSegment(at: 0, animated: false)
        burgerMenuItem = navigationItem.leftBarButtonItem
    }

    func canRotate() -> Bool {
        return true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        initialiseMap()

        if let currentMapEntryMap = currentMapEntry?.Map, let mapIndex = mapIdToIndex[currentMapEntryMap.Id] {
            switchToMap(mapIndex, zoom: false)
            navigationItem.leftBarButtonItems = []
        } else {
            if currentMap >= 0 && currentMap < mapViews.count {
                switchToMap(currentMap, zoom: false)
            }
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        currentMapEntry = nil
    }

    func initialiseMap() {
        currentMap = 0
        mapIdToIndex = [:]
        mapViews = []
        mapEntries = []

        mapSwitchControl.removeAllSegments()
        mapSwitchControl.insertSegment(withTitle: "Area", at: 0, animated: false)

        let maps = dataContext.Maps.value
        for map in maps {
            if map.IsBrowseable {
                //print(map.Description, "(", map.Id, ") is currently valid, added!")
                let mapView = UIImageView(image: MapViewController.imagePlaceholder)
				// TODO: Implement image cache
                /*ImageManager.sharedInstance.retrieveFromCache(map.ImageId!, imagePlaceholder: MapViewController.imagePlaceholder, completion: {
                    image in
                    mapView.image = image
                    mapView.sizeToFit()
                })*/
                mapView.contentMode = UIViewContentMode.scaleAspectFit
                mapView.layer.cornerRadius = 11.0
                mapView.clipsToBounds = false
                mapView.backgroundColor = UIColor.white

                mapViews.append(mapView)
                mapIdToIndex[map.Id] = mapViews.count - 1

                mapSwitchControl.insertSegment(withTitle: map.Description, at: mapSwitchControl.numberOfSegments - 1, animated: false)

                mapEntries.append(map.Entries)
            } else {
                //print(map.Description, "(", map.Id, ") is currently not valid, skipping...")
            }
        }
    }

    func notificationRefresh(_ notification: Notification) {
        DispatchQueue.main.async {
            self.initialiseMap()
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

		if let currentMapEntry = currentMapEntry, let currentMap = currentMapEntry.Map, let mapIndex = mapIdToIndex[currentMap.Id], let mapImage = mapViews[mapIndex].image {

			let mapEntryLocation = CGPoint(x: CGFloat(currentMapEntry.X), y: CGFloat(currentMapEntry.Y))
			let tapRadius = CGFloat(currentMapEntry.TapRadius)

            var height: CGFloat!
            var width: CGFloat!
            if mapContainerView.frame.height > mapContainerView.frame.width {
                let ratio = mapContainerView.frame.width / mapContainerView.frame.height
                height = tapRadius * currentMapEntryRadiusMultiplier
                width = height * ratio
            } else {
                let ratio = mapContainerView.frame.height / mapContainerView.frame.width
                width = tapRadius * currentMapEntryRadiusMultiplier
                height = width * ratio
            }
            let offsetX = min(max(0.0, mapEntryLocation.x - width / 2.0), mapImage.size.width - width)
            let offsetY = min(max(0.0, mapEntryLocation.y - height / 2.0), mapImage.size.height - height)
            let targetRect = CGRect(
                x: offsetX,
                y: offsetY,
                width: width,
                height: height
            )
            adjustZoomToFit(targetRect, animated: true)
        } else {
            adjustZoomToFit()
        }
    }

    /// Switches the currently displayed map to `mapID`. Will do reload map if
    /// given map is already being displayed
    /// - parameters:
    ///   - mapId: id of map to be displayed (see class constants for details)
    func switchToMap(_ mapId: Int, zoom: Bool = true) {
        mapContainerView.subviews.forEach({ $0.removeFromSuperview() })

        if mapId < mapViews.count {
            let mapView = mapViews[mapId]
            mapContainerView.contentSize = mapView.bounds.size
            mapContainerView.addSubview(mapView)
            if zoom {
                adjustZoomToFit()
            }
            mapSwitchControl.selectedSegmentIndex = mapId
            currentMap = mapId
        } else if mapViews.count > 0 {
            switchToMap(0)
        } else {
            //print("No maps available!")
        }

    }

    @IBAction func mapSwitchChanged(_ segmentedControl: UISegmentedControl) {
        if segmentedControl.selectedSegmentIndex == mapViews.count {
            present(RoutingAppChooser.sharedInstance.getAlertForAddress("Estrel Hotel Berlin", house: "225", street: "Sonnenallee", zip: "12057", city: "Berlin", country: "Germany", lat: 52.473336, lon: 13.458729), animated: true, completion:nil)
            segmentedControl.selectedSegmentIndex = currentMap
        } else {
            switchToMap(segmentedControl.selectedSegmentIndex)
            currentMapEntry = nil
            currentMapEntryRadiusMultiplier = 1.0
            navigationItem.leftBarButtonItems = [burgerMenuItem]
        }
    }

    func checkMapEntries(_ tapGesture: UITapGestureRecognizer) {
        if let mapImageView = mapContainerView.subviews.first as? UIImageView, currentMap < mapEntries.count && !mapEntries[currentMap].isEmpty {

            let tapLocation = tapGesture.location(in: mapImageView)
            var nearestMapEntry: MapEntry? = nil
            var nearestMapEntryDistanceSquared = CGFloat(-1.0)
            for mapEntry in mapEntries[currentMap] {
				let mapEntryLocation = CGPoint(x: CGFloat(mapEntry.X), y: CGFloat(mapEntry.Y))
				let tapRadius = CGFloat(mapEntry.TapRadius)

				let deltaX = abs(tapLocation.x - mapEntryLocation.x)
				let deltaY = abs(tapLocation.y - mapEntryLocation.y)
				let distanceSquared = deltaX * deltaX + deltaY * deltaY

				if distanceSquared <= tapRadius * tapRadius && (nearestMapEntry == nil || distanceSquared < nearestMapEntryDistanceSquared) {

					nearestMapEntryDistanceSquared = distanceSquared
					nearestMapEntry = mapEntry
				}
            }

			// TODO: Reimplement with LinkFragment types
            /*if let nearestMapEntry = nearestMapEntry {
                switch nearestMapEntry.MarkerType {
                case "Dealer":
                    if let dealer = Dealer.getById(nearestMapEntry.TargetId) {
                        self.performSegue(withIdentifier: "MapToDealerDetailViewSegue", sender: dealer)
                    }
                    break
                case "EventConferenceRoom":
                    if let mapEntry = MapEntry.getByTargetId(nearestMapEntry.Id) {
                        currentMapEntry = mapEntry
                        currentMapEntryRadiusMultiplier = 30.0
                        viewDidLayoutSubviews()
                    }
                    break
                case "MapEntry":
                    if let mapEntry = MapEntry.getById(nearestMapEntry.TargetId) {
                        currentMapEntry = mapEntry
                        currentMapEntryRadiusMultiplier = 30.0
                        viewDidLayoutSubviews()
                    }
                default:
                    print("Unsupported MarkerType", nearestMapEntry.MarkerType)
                }
            }*/
        }
    }

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.mapContainerView.subviews.first
    }

    func zoom(_ tapGesture: UITapGestureRecognizer) {
        if (mapContainerView.zoomScale < mapContainerView.maximumZoomScale) {
            mapContainerView.setZoomScale(mapContainerView.zoomScale + mapContainerView.maximumZoomScale /  CGFloat(MapViewController.ZOOM_STEPS), animated: true)
        } else {
            mapContainerView.setZoomScale(mapContainerView.minimumZoomScale, animated: true)
        }
    }

    func computeZoomFactor(_ target: CGRect, container: CGRect) -> CGFloat {
        let deltaWidth = abs(target.width - container.width)
        let deltaHeight = abs(target.height - container.height)

        // Determine whether height or width are more dominant and zoom to fit the less dominant factor
        if deltaWidth / container.width < deltaHeight / container.height {
            // scale for width
            return container.width/target.width
        } else {
            //scale for height
            return container.height/target.height
        }
    }

    func adjustZoomToFit(_ rect: CGRect? = nil, animated: Bool = false) {

        var targetRect: CGRect!
        var zoomFactor: CGFloat!

        let imageView = mapContainerView.subviews.first as! UIImageView
        let imageSize = imageView.image!.size
        let imageRect = CGRect(origin: CGPoint.zero, size: imageSize)
        zoomFactor = CGFloat(min(1.0, computeZoomFactor(imageRect, container: mapContainerView.bounds)))
        mapContainerView.minimumZoomScale = zoomFactor * MapViewController.MIN_ZOOM_SCALE_FACTOR

        if rect == nil {
            mapContainerView.maximumZoomScale = zoomFactor * MapViewController.MAX_ZOOM_SCALE_FACTOR
            targetRect = CGRect(
                x: imageSize.width * zoomFactor / 2 - mapContainerView.bounds.width / 2,
                y: imageSize.height * zoomFactor / 2 - mapContainerView.bounds.height / 2,
                width: mapContainerView.bounds.width,
                height: mapContainerView.bounds.height
            )
        } else {
            zoomFactor = computeZoomFactor(rect!, container: mapContainerView.bounds)
            targetRect = CGRect(
                x: rect!.minX * zoomFactor,
                y: rect!.minY * zoomFactor,
                width: mapContainerView.bounds.width,
                height: mapContainerView.bounds.height
            )
        }
        mapContainerView!.setZoomScale(zoomFactor, animated: animated)

        mapContainerView.scrollRectToVisible(targetRect, animated: animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
     */

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MapToDealerDetailViewSegue" {
            if let destinationVC = segue.destination as? DealerViewController, let dealer = sender as? Dealer {
                destinationVC.dealer = dealer
            }
        }
    }

    @IBAction func openMenu(_ sender: AnyObject) {
        if let _ = self.slideMenuController() {
            self.slideMenuController()?.openLeft()
        }
    }

}
