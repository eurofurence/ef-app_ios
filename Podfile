platform :ios, '10.0'
inhibit_all_warnings!
use_frameworks!
workspace 'Eurofurence.xcworkspace'

target :Eurofurence do
  project 'Eurofurence.xcodeproj'
  plugin 'cocoapods-acknowledgements', :settings_bundle => true
  
  pod 'Crashlytics'
  pod 'Down'
  pod 'Fabric'
  pod 'Firebase/Core'
  pod 'Firebase/Messaging'
  pod 'Firebase/Performance'
  
  pod 'SimulatorStatusMagic', :configurations => ['Screenshots']
  
  target :EurofurenceTests do
    inherit! :search_paths
  end
  
  target :Screenshots
  
end
