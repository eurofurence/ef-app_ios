import Combine
import EurofurenceApplication
import XCTest

class RepositoryBackedAppIconsViewModelTests: XCTestCase {
    
    func testAdaptsIconsFromRepository() throws {
        let icon = AppIcon(displayName: "Display Name", imageFileName: "File Name", alternateIconName: "Alternate Name")
        let repository = StubAppIconRepository(availableIcons: [icon])
        let applicationIconState = StubApplicationIconState()
        let viewModel = RepositoryBackedAppIconsViewModel(
            repository: repository,
            applicationIconState: applicationIconState
        )
        
        let iconViewModel = try XCTUnwrap(viewModel.icons.first)
        
        XCTAssertEqual("Display Name", iconViewModel.displayName)
        XCTAssertEqual("File Name", iconViewModel.imageName)
        XCTAssertFalse(iconViewModel.isCurrentAppIcon)
    }
    
    func testInfersCurrentAppIcon() throws {
        let icon = AppIcon(displayName: "Display Name", imageFileName: "File Name", alternateIconName: "Alternate Name")
        let repository = StubAppIconRepository(availableIcons: [icon])
        let applicationIconState = StubApplicationIconState()
        applicationIconState.updateApplicationIcon(alternateIconName: "Alternate Name")
        let viewModel = RepositoryBackedAppIconsViewModel(
            repository: repository,
            applicationIconState: applicationIconState
        )
        
        let iconViewModel = try XCTUnwrap(viewModel.icons.first)
        
        XCTAssertEqual("Display Name", iconViewModel.displayName)
        XCTAssertEqual("File Name", iconViewModel.imageName)
        XCTAssertTrue(iconViewModel.isCurrentAppIcon)
    }
    
    func testSelectingNewAppIcon() throws {
        let icon = AppIcon(displayName: "Display Name", imageFileName: "File Name", alternateIconName: "Alternate Name")
        let repository = StubAppIconRepository(availableIcons: [icon])
        let applicationIconState = StubApplicationIconState()
        let viewModel = RepositoryBackedAppIconsViewModel(
            repository: repository,
            applicationIconState: applicationIconState
        )
        
        let iconViewModel = try XCTUnwrap(viewModel.icons.first)
        iconViewModel.selectAsAppIcon()
        
        XCTAssertEqual("Alternate Name", applicationIconState.alternateIconNamePublisher.value)
        XCTAssertTrue(iconViewModel.isCurrentAppIcon)
    }
    
    func testUpdatesCurrentSelectionStateForOtherAppIcons() throws {
        let firstIcon = AppIcon(
            displayName: "First Display Name",
            imageFileName: "First File Name",
            alternateIconName: "First Alternate Name"
        )
        
        let secondIcon = AppIcon(
            displayName: "Second Display Name",
            imageFileName: "Second File Name",
            alternateIconName: "Second Alternate Name"
        )
        
        let repository = StubAppIconRepository(availableIcons: [firstIcon, secondIcon])
        let applicationIconState = StubApplicationIconState()
        applicationIconState.updateApplicationIcon(alternateIconName: "Second Alternate Name")
        let viewModel = RepositoryBackedAppIconsViewModel(
            repository: repository,
            applicationIconState: applicationIconState
        )
        
        if viewModel.icons.count != 2 {
            struct ViewModelNotFound: Error { }
            throw ViewModelNotFound()
        }
        
        let firstIconViewModel = viewModel.icons[0]
        let secondIconViewModel = viewModel.icons[1]
        
        XCTAssertFalse(firstIconViewModel.isCurrentAppIcon)
        XCTAssertTrue(secondIconViewModel.isCurrentAppIcon)
        
        firstIconViewModel.selectAsAppIcon()
        
        XCTAssertTrue(firstIconViewModel.isCurrentAppIcon)
        XCTAssertFalse(secondIconViewModel.isCurrentAppIcon)
    }
    
    private struct StubAppIconRepository: AppIconRepository {
        
        private let availableIcons: [AppIcon]
        
        init(availableIcons: [AppIcon]) {
            self.availableIcons = availableIcons
        }
        
        func loadAvailableIcons() -> [AppIcon] {
            availableIcons
        }
        
    }

}
