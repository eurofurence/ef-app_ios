import EurofurenceModel
import ScheduleComponent
import UIKit.UIViewController
import XCTComponentBase

class CapturingScheduleScene: UIViewController, ScheduleScene {

    private(set) var delegate: ScheduleSceneDelegate?
    func setDelegate(_ delegate: ScheduleSceneDelegate) {
        self.delegate = delegate
    }

    private(set) var capturedTitle: String?
    func setScheduleTitle(_ title: String) {
        capturedTitle = title
    }

    private(set) var didShowRefreshIndicator = false
    func showRefreshIndicator() {
        didShowRefreshIndicator = true
    }

    private(set) var didHideRefreshIndicator = false
    func hideRefreshIndicator() {
        didHideRefreshIndicator = true
    }

    private(set) var boundNumberOfDays: Int?
    private(set) var daysBinder: ScheduleDaysBinder?
    func bind(numberOfDays: Int, using binder: ScheduleDaysBinder) {
        boundNumberOfDays = numberOfDays
        daysBinder = binder
    }

    private(set) var boundItemsPerSection: [Int] = []
    private(set) var binder: ScheduleSceneBinder?
    func bind(numberOfItemsPerSection: [Int], using binder: ScheduleSceneBinder) {
        boundItemsPerSection = numberOfItemsPerSection
        self.binder = binder
    }

    private(set) var selectedDayIndex: Int?
    func selectDay(at index: Int) {
        selectedDayIndex = index
    }

    private(set) var boundSearchItemsPerSection = [Int]()
    private(set) var searchResultsBinder: ScheduleSceneBinder?
    func bindSearchResults(numberOfItemsPerSection: [Int], using binder: ScheduleSceneBinder) {
        boundSearchItemsPerSection = numberOfItemsPerSection
        searchResultsBinder = binder
    }

    private(set) var didShowSearchResults = false
    private(set) var didShowSearchResultsCount = 0
    func showSearchResults() {
        didShowSearchResults = true
        didShowSearchResultsCount += 1
    }

    private(set) var didHideSearchResults = false
    func hideSearchResults() {
        didHideSearchResults = true
    }
    
    enum VisibleFilterButton: Equatable {
        case unknown
        case filterToFavourites
        case filterToAllEvents
    }
    
    private(set) var visibleFilterButton: VisibleFilterButton = .unknown
    func showFilterToFavouritesButton() {
        visibleFilterButton = .filterToFavourites
    }
    
    func showFilterToAllEventsButton() {
        visibleFilterButton = .filterToAllEvents
    }

}
