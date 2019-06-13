platform :ios, '10.0'
inhibit_all_warnings!
use_frameworks!
workspace 'Eurofurence.xcworkspace'

target :TestUtilities do
  project 'Shared Kernel/Shared Kernel.xcodeproj'
  pod 'SwiftLint'
end

target :EventBus do
  project 'Shared Kernel/Shared Kernel.xcodeproj'
  pod 'SwiftLint'
end

target :Eurofurence do
  project 'Eurofurence.xcodeproj'
  plugin 'cocoapods-acknowledgements', :settings_bundle => true
  
  pod 'Crashlytics'
  pod 'Down'
  pod 'Fabric'
  pod 'Firebase/Core'
  pod 'Firebase/Messaging'
  pod 'Firebase/Performance'
  pod 'SwiftLint'
  
  pod 'SimulatorStatusMagic', :configurations => ['Screenshots']
  
  target :EurofurenceTests do
    inherit! :search_paths
  end
  
  target :EurofurenceUITests do
    inherit! :search_paths
  end
  
  target :ScreenshotGenerator do
    inherit! :search_paths
  end
  
end

target :EurofurenceModel do
  project 'Domain Model/Domain Model.xcodeproj'
  
  pod 'SwiftLint'
  
  target :EurofurenceModelTests do
    inherit! :search_paths
  end
  
  target :EurofurenceModelAdapterTests do
    inherit! :search_paths
  end
  
  target :EurofurenceModelTestDoubles do
    inherit! :search_paths
  end
  
end
