//
//  MapViewController.swift
//  Eurofurence
//
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import UIKit
import ReactiveSwift

class MapViewController: UIViewController, UIScrollViewDelegate {
    static let imagePlaceholder = UIImage(named: "ef")
    static let ZOOM_STEPS = 3
    static let MAX_ZOOM_SCALE_FACTOR: CGFloat = 5.0
    static let MIN_ZOOM_SCALE_FACTOR: CGFloat = 1.0

    @IBOutlet weak var mapContainerView: UIScrollView!
    @IBOutlet weak var mapSwitchControl: UISegmentedControl!
    var burgerMenuItem: UIBarButtonItem!
    var doubleTap: UITapGestureRecognizer!
    var singleTap: UITapGestureRecognizer!
	weak var map: Map?
    weak var mapEntry: MapEntry?
	weak var mapView: UIImageView?
    var currentMapEntryRadiusMultiplier = CGFloat(1.0)
	var disposables = CompositeDisposable()

	let viewModel: MapViewModel = try! ViewModelResolver.container.resolve()
	let imageService: ImageServiceProtocol = try! ServiceResolver.container.resolve()

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

		disposables += viewModel.BrowsableMaps.signal.observeResult({[unowned self] _ in
			DispatchQueue.main.async {
				self.reloadData()
			}
		})

        reloadData()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

		mapEntry = nil
		disposables.dispose()
		disposables = CompositeDisposable()
	}

	private func getMapEntryTargetRect() -> CGRect? {
		guard let mapEntry = mapEntry, let mapImage = mapView?.image else {
			return nil
		}

		var height: CGFloat!
		var width: CGFloat!
		if mapContainerView.frame.height > mapContainerView.frame.width {
			let ratio = mapContainerView.frame.width / mapContainerView.frame.height
			height = mapEntry.CGTapRadius * currentMapEntryRadiusMultiplier
			width = height * ratio
		} else {
			let ratio = mapContainerView.frame.height / mapContainerView.frame.width
			width = mapEntry.CGTapRadius * currentMapEntryRadiusMultiplier
			height = width * ratio
		}
		let offsetX = min(max(0.0, mapEntry.CGX - width / 2.0), mapImage.size.width - width)
		let offsetY = min(max(0.0, mapEntry.CGY - height / 2.0), mapImage.size.height - height)
		return CGRect(
			x: offsetX,
			y: offsetY,
			width: width,
			height: height
		)
	}

	func adjustZoom(_ animated: Bool = false) {
		guard let image = mapView?.image else {
			return
		}

		var zoomFactor: CGFloat!

		let imageRect = CGRect(origin: CGPoint.zero, size: image.size)
		zoomFactor = CGFloat(min(1.0, computeZoomFactor(imageRect, container: mapContainerView.bounds)))
		mapContainerView.minimumZoomScale = zoomFactor * MapViewController.MIN_ZOOM_SCALE_FACTOR

		let zoomedTargetRect: CGRect
		if let targetRect = getMapEntryTargetRect() {
			zoomFactor = computeZoomFactor(targetRect, container: mapContainerView.bounds)
			zoomedTargetRect = CGRect(
				x: targetRect.minX * zoomFactor,
				y: targetRect.minY * zoomFactor,
				width: mapContainerView.bounds.width,
				height: mapContainerView.bounds.height
			)
		} else {
			mapContainerView.maximumZoomScale = zoomFactor * MapViewController.MAX_ZOOM_SCALE_FACTOR
			zoomedTargetRect = CGRect(
				x: image.size.width * zoomFactor / 2 - mapContainerView.bounds.width / 2,
				y: image.size.height * zoomFactor / 2 - mapContainerView.bounds.height / 2,
				width: mapContainerView.bounds.width,
				height: mapContainerView.bounds.height
			)
		}
		mapContainerView.setZoomScale(zoomFactor, animated: animated)
		mapContainerView.scrollRectToVisible(zoomedTargetRect, animated: animated)
	}

	func computeZoomFactor(_ target: CGRect, container: CGRect) -> CGFloat {
		let deltaWidth = abs(target.width - container.width)
		let deltaHeight = abs(target.height - container.height)

		// Determine whether height or width are more dominant and zoom to fit the less dominant factor
		if deltaWidth / container.width < deltaHeight / container.height {
			// scale for width
			return container.width / target.width
		} else {
			//scale for height
			return container.height / target.height
		}
	}

	func reloadData() {
		let maps = viewModel.BrowsableMaps.value

		mapSwitchControl.removeAllSegments()
		mapSwitchControl.insertSegment(withTitle: "Area", at: 0, animated: false)

		for map in maps {
			mapSwitchControl.insertSegment(withTitle: map.Description, at: mapSwitchControl.numberOfSegments - 1, animated: false)
		}

		if let mapEntry = mapEntry, let map = mapEntry.Map {
			self.map = map
		} else if map == nil && maps.count > 0 {
			map = maps[0]
		}

		if let map = map, let selectedIndex = maps.index(of: map) {
			mapSwitchControl.selectedSegmentIndex = selectedIndex
			show(map: map)
		} else {
			show(map: nil)
		}
	}

    func notificationRefresh(_ notification: Notification) {
        DispatchQueue.main.async {
            self.reloadData()
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

		adjustZoom(true)
    }

    /// Switches the view to map. Will do reload map if
    /// given map is already being displayed.
    /// - parameters:
    ///   - map: map to be displayed
    func show(map: Map?) {
        mapContainerView.subviews.forEach({ $0.removeFromSuperview() })
		let mapView = UIImageView(image: MapViewController.imagePlaceholder)
		mapView.contentMode = UIViewContentMode.scaleAspectFit
		mapView.layer.cornerRadius = 11.0
		mapView.clipsToBounds = false
		mapView.backgroundColor = UIColor.white
		mapContainerView.contentSize = mapView.bounds.size
		mapContainerView.addSubview(mapView)

		if let mapEntry = mapEntry, mapEntry.Map == nil || mapEntry.Map != map {
			self.mapEntry = nil
		}

		guard let map = map, let mapImage = map.Image else {
			return
		}

		disposables += imageService.retrieve(for: mapImage).startWithResult({
			[unowned self] result in
			switch result {
			case let .success(value):
				DispatchQueue.main.async {
					mapView.sizeThatFits(value.size)
					mapView.image = value
					self.mapContainerView.contentSize = mapView.bounds.size
					self.map = map
					self.adjustZoom(true)
				}
				break
			case .failure:
				// TODO: Notify user about failure to load map
				break
			}
		})
    }

    @IBAction func mapSwitchChanged(_ segmentedControl: UISegmentedControl) {
		let maps = viewModel.BrowsableMaps.value
        if segmentedControl.selectedSegmentIndex == segmentedControl.numberOfSegments - 1 {
            present(RoutingAppChooser.sharedInstance.getAlertForAddress("Estrel Hotel Berlin", house: "225", street: "Sonnenallee", zip: "12057", city: "Berlin", country: "Germany", lat: 52.473336, lon: 13.458729), animated: true, completion:nil)
			if let map = map, let currentMapIndex = maps.index(of: map) {
				segmentedControl.selectedSegmentIndex = currentMapIndex
			} else if maps.count > 0 {
				show(map: maps[0])
			} else {
				show(map: nil)
			}
        } else if segmentedControl.selectedSegmentIndex <= maps.count {
			show(map: maps[segmentedControl.selectedSegmentIndex])
            mapEntry = nil
            currentMapEntryRadiusMultiplier = 1.0
            navigationItem.leftBarButtonItems = [burgerMenuItem]
        }
    }

    func checkMapEntries(_ tapGesture: UITapGestureRecognizer) {
        guard let map = map, let mapView = mapView else {
			return
		}
		let tapLocation = tapGesture.location(in: mapView)
		var nearestMapEntry: MapEntry? = nil
		var nearestMapEntryDistanceSquared = CGFloat(-1.0)
		for mapEntry in map.Entries {
			let deltaX = abs(tapLocation.x - mapEntry.CGX)
			let deltaY = abs(tapLocation.y - mapEntry.CGY)
			let distanceSquared = deltaX * deltaX + deltaY * deltaY

			if distanceSquared <= mapEntry.CGTapRadius * mapEntry.CGTapRadius &&
				(nearestMapEntry == nil || distanceSquared < nearestMapEntryDistanceSquared) {

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

    func zoom(_ tapGesture: UITapGestureRecognizer) {
        if (mapContainerView.zoomScale < mapContainerView.maximumZoomScale) {
            mapContainerView.setZoomScale(mapContainerView.zoomScale + mapContainerView.maximumZoomScale /  CGFloat(MapViewController.ZOOM_STEPS), animated: true)
        } else {
            mapContainerView.setZoomScale(mapContainerView.minimumZoomScale, animated: true)
        }
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
