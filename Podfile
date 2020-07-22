platform :ios, '11.0'
inhibit_all_warnings!
use_frameworks!
workspace 'Eurofurence.xcworkspace'

target :Eurofurence do
  project 'Eurofurence.xcodeproj'
  plugin 'cocoapods-acknowledgements', :settings_bundle => true
  
  pod 'Down'
  pod 'Firebase/Core'
  pod 'Firebase/Crashlytics'
  pod 'Firebase/Messaging'
  pod 'Firebase/Performance'
    
  target :EurofurenceTests do
    inherit! :search_paths
  end
  
  target :Screenshots
  
end
