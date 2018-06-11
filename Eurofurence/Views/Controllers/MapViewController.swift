//
//  MapViewController.swift
//  Eurofurence
//
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import UIKit
import ReactiveSwift

class MapViewController: UIViewController, UIScrollViewDelegate {
    static let ZOOM_STEPS = 3
    static let MAX_ZOOM_SCALE_FACTOR: CGFloat = 5.0
    static let MIN_ZOOM_SCALE_FACTOR: CGFloat = 1.0

    @IBOutlet weak var mapContainerView: UIScrollView!
	@IBOutlet weak var mapResetZoomButton: UIButton!
    @IBOutlet weak var mapSwitchControl: UISegmentedControl!
    var doubleTap: UITapGestureRecognizer!
    var singleTap: UITapGestureRecognizer!
	weak var map: Map?
    weak var mapEntry: MapEntry?
	var mapView: UIImageView?
    var currentMapEntryRadiusMultiplier = CGFloat(1.0)
	var disposables = CompositeDisposable()

	let viewModel: MapViewModel = try! ViewModelResolver.container.resolve()
	let imageService: ImageServiceProtocol = try! ServiceResolver.container.resolve()

    override func viewDidLoad() {
        super.viewDidLoad()

		view.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "Background Tile"))

        // setup map container
        mapContainerView.delegate = self
        mapContainerView.minimumZoomScale = 1.0
        mapContainerView.maximumZoomScale = 5.0

        // add zoom on double tap
        doubleTap = UITapGestureRecognizer(target: self, action: #selector(MapViewController.zoom(_:)))
        doubleTap.numberOfTapsRequired = 2
        mapContainerView.addGestureRecognizer(doubleTap!)

        // add map entry on single tap
        singleTap = UITapGestureRecognizer(target: self, action: #selector(MapViewController.checkMapEntries(_:)))
        mapContainerView.addGestureRecognizer(singleTap!)

		mapResetZoomButton.addTarget(self, action: #selector(MapViewController.adjustZoom(animated:doPanAndZoom:)),
		                             for: .touchUpInside)

        NotificationCenter.default.addObserver(self, selector: #selector(MapViewController.notificationRefresh(_:)),
                                               name: NSNotification.Name(rawValue: "reloadData"), object: nil)
        mapSwitchControl.removeSegment(at: 0, animated: false)

		disposables += viewModel.BrowsableMaps.signal.observeResult({[weak self] _ in
			guard let strongSelf = self else { return }
			DispatchQueue.main.async {
				strongSelf.reloadData()
			}
		})

		reloadData()
    }

    func canRotate() -> Bool {
        return true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

		showMap()
	}

	private func showMap() {
		var maps = viewModel.BrowsableMaps.value
		if let mapEntry = mapEntry, let map = mapEntry.Map, maps.contains(map) {
			navigationItem.leftBarButtonItem = nil
			mapSwitchControl.isHidden = true
			show(map: map, animated: true)
		} else if map == nil && maps.count > 0 {
			mapSwitchControl.isHidden = false
			show(map: maps[0], animated: false)
		}
	}

	func reloadData() {
		mapSwitchControl.removeAllSegments()
		mapSwitchControl.insertSegment(withTitle: "Area", at: 0, animated: false)

		for map in viewModel.BrowsableMaps.value {
			mapSwitchControl.insertSegment(withTitle: map.Description, at: mapSwitchControl.numberOfSegments - 1, animated: false)
		}

		if isViewLoaded && view.window != nil {
			showMap()
		}
	}

    override func viewWillDisappear(_ animated: Bool) {

		mapEntry = nil
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

	@IBAction func resetZoom() {
		mapEntry = nil
		adjustZoom(animated: true, doPanAndZoom: true)
	}

	@objc func adjustZoom(animated: Bool = false, doPanAndZoom: Bool = true) {
		guard let mapImage = mapView?.image else {
			return
		}
		var zoomFactor: CGFloat!

		let imageRect = CGRect(origin: CGPoint.zero, size: mapImage.size)
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
			zoomedTargetRect = CGRect(
				x: (imageRect.width * zoomFactor - mapContainerView.bounds.width) / 2.0,
				y: (imageRect.height * zoomFactor - mapContainerView.bounds.height) / 2.0,
				width: mapContainerView.bounds.width,
				height: mapContainerView.bounds.height
			)
		}

		mapContainerView.maximumZoomScale = zoomFactor * MapViewController.MAX_ZOOM_SCALE_FACTOR

		if doPanAndZoom {
			mapContainerView.setZoomScale(zoomFactor, animated: animated)
			mapContainerView.scrollRectToVisible(zoomedTargetRect, animated: animated)
		}
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

    @objc func notificationRefresh(_ notification: Notification) {
        DispatchQueue.main.async {
            self.reloadData()
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

		adjustZoom(doPanAndZoom: false)
    }

	private func createMapView(for image: UIImage?) -> UIImageView {
		let mapView = UIImageView(image: image)
		mapView.contentMode = UIViewContentMode.scaleAspectFit
		mapView.layer.cornerRadius = 11.0
		mapView.clipsToBounds = false
		mapView.backgroundColor = UIColor.white
		return mapView
	}

	func show(mapEntry: MapEntry, animated: Bool = true) {
		guard let map = mapEntry.Map, map.IsBrowseable else {
			print("MapEntry without associated map or non-browsable map!")
			return
		}

		self.mapEntry = mapEntry
		show(map: map, animated: animated)
	}

    /// Switches the view to map. Will do reload map if
    /// given map is already being displayed.
    /// - parameters:
    ///		- map: map to be displayed
	///		- animated: should zooming and panning the new map to fit be animated?
	func show(map: Map?, animated: Bool = false) {
		if let mapEntry = mapEntry, mapEntry.Map == nil || mapEntry.Map != map {
			self.mapEntry = nil
		}

		guard let map = map, let mapImage = map.Image,
				let mapIndex = viewModel.BrowsableMaps.value.index(of: map) else {
			print("No map, map without image or non-browsable map! Falling back to default placeholder…")
			mapContainerView.subviews.forEach({ $0.removeFromSuperview() })
			return
		}

		DispatchQueue.main.async {
			self.mapSwitchControl.selectedSegmentIndex = mapIndex
		}

		guard map != self.map else {
			adjustZoom(animated: animated)
			return
		}
		mapContainerView.subviews.forEach({ $0.removeFromSuperview() })

		disposables += imageService.retrieve(for: mapImage).startWithResult({
			[unowned self] result in
			switch result {
			case let .success(value):
				DispatchQueue.main.async {
					self.mapContainerView.subviews.forEach({ $0.removeFromSuperview() })
					self.mapView = self.createMapView(for: value)
					guard let mapView = self.mapView else { return }
					self.mapContainerView.contentSize = mapView.bounds.size
					self.mapContainerView.addSubview(mapView)
					self.map = map
					self.adjustZoom(animated: animated)
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
		mapEntry = nil
        if segmentedControl.selectedSegmentIndex == segmentedControl.numberOfSegments - 1 {
            present(RoutingAppChooser.sharedInstance.getAlertForAddress("Estrel Hotel Berlin", house: "225", street: "Sonnenallee", zip: "12057", city: "Berlin", country: "Germany", lat: 52.473336, lon: 13.458729), animated: true, completion: nil)
			if let map = map, let currentMapIndex = maps.index(of: map) {
				segmentedControl.selectedSegmentIndex = currentMapIndex
			} else if maps.count > 0 {
				show(map: maps[0])
			} else {
				show(map: nil)
			}
        } else if segmentedControl.selectedSegmentIndex <= maps.count {
			show(map: maps[segmentedControl.selectedSegmentIndex])
            currentMapEntryRadiusMultiplier = 1.0
        }
    }

    @objc func checkMapEntries(_ tapGesture: UITapGestureRecognizer) {
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

		if let nearestMapEntry = nearestMapEntry, nearestMapEntry.Links.count > 0 {
			if let link = nearestMapEntry.Links.first, nearestMapEntry.Links.count == 1 {
				performLinkFragmentAction(for: link)
			} else {
				showMapEntryActionSheet(for: nearestMapEntry)
			}
		}
    }

	func performLinkFragmentAction(for linkFragment: LinkFragment) {
		switch linkFragment.FragmentType {
		case .DealerDetail:
			if let dealer: Dealer = linkFragment.getTarget() {
				self.performSegue(withIdentifier: "MapToDealerDetailViewSegue", sender: dealer)
			}
		case .MapExternal:
			break
		case .MapEntry:
			if let linkMapEntry: MapEntry = linkFragment.getTarget() {
				currentMapEntryRadiusMultiplier = 10.0
				self.show(mapEntry: linkMapEntry)
			}
		case .WebExternal:
			if let url: URL = linkFragment.getTarget() {
				UIApplication.shared.openURL(url)
			}
		default:
			break
		}
	}

	func showMapEntryActionSheet(for mapEntry: MapEntry) {
        let mapEntryLinks = mapEntry.Links
		guard mapEntryLinks.count > 0 else { return }

		let firstFragmentType: LinkFragment.LinkFragmentType = mapEntryLinks[0].FragmentType
		let hasMultipleFragmentTypes = mapEntryLinks.contains { $0.FragmentType != firstFragmentType }

		let optionMenuMessage: String
		if hasMultipleFragmentTypes {
			optionMenuMessage = "Select a map entry"
		} else {
			switch firstFragmentType {
			case .DealerDetail:
				optionMenuMessage = "Select a dealer"
			case .MapExternal:
				optionMenuMessage = "Select an external map location"
			case .MapEntry:
				optionMenuMessage = "Select a map location"
			case .WebExternal:
				optionMenuMessage = "Select a web link"
			default:
				return
			}
		}

		let optionMenu = UIAlertController(title: nil, message: optionMenuMessage, preferredStyle: .actionSheet)

        if let popoverPresentationController = optionMenu.popoverPresentationController {
            let width = mapEntry.CGTapRadius, height = mapEntry.CGTapRadius
            let left = mapEntry.CGLocation.x - width / 2
            let top = mapEntry.CGLocation.y - height / 2
            let sourceRect = CGRect(x: left, y: top, width: width, height: height)

            popoverPresentationController.sourceRect = sourceRect
            popoverPresentationController.sourceView = mapView
        }

		var lastActionableLink: LinkFragment?
		for link in mapEntryLinks {
			// TODO: Prepend FontAwesome icon depending on LinkFragment.Type
			var actionTitle = link.Name
			switch link.FragmentType {
			case .DealerDetail:
				if let _: Dealer = link.getTarget() {
					actionTitle = hasMultipleFragmentTypes ? "Dealer: \(actionTitle)" : actionTitle
				} else {
					continue
				}
			case .MapExternal:
				// TODO: How can the target string be parsed to a location?
				continue
			case .MapEntry:
				if let _: MapEntry = link.getTarget() {
					actionTitle = hasMultipleFragmentTypes ? "Map: \(actionTitle)" : actionTitle
				} else {
					continue
				}
			case .WebExternal:
				if let _: URL = link.getTarget() {
					actionTitle = hasMultipleFragmentTypes ? "Web: \(actionTitle)" : actionTitle
				} else {
					continue
				}
			default:
				continue
			}

			let linkAction = UIAlertAction(title: actionTitle, style: .default, handler: {
				(_: UIAlertAction!) -> Void in
				DispatchQueue.main.async {
					self.performLinkFragmentAction(for: link)
				}
			})
			lastActionableLink = link
			optionMenu.addAction(linkAction)
		}

		guard optionMenu.actions.count > 1 else {
			if let lastActionableLink = lastActionableLink {
				performLinkFragmentAction(for: lastActionableLink)
			}
			return
		}

		let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
			(_: UIAlertAction!) -> Void in
		})
		optionMenu.addAction(cancelAction)

		self.present(optionMenu, animated: true, completion: nil)
	}

	func viewForZooming(in scrollView: UIScrollView) -> UIView? {
		return scrollView.subviews.first
	}

    @objc func zoom(_ tapGesture: UITapGestureRecognizer) {
        if (mapContainerView.zoomScale < mapContainerView.maximumZoomScale) {
            mapContainerView.setZoomScale(mapContainerView.zoomScale + mapContainerView.maximumZoomScale /  CGFloat(MapViewController.ZOOM_STEPS), animated: true)
        } else {
            mapContainerView.setZoomScale(mapContainerView.minimumZoomScale, animated: true)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
		disposables.dispose()
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

}
