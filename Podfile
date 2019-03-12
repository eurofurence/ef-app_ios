platform :ios, '10.0'
inhibit_all_warnings!
use_frameworks!

target :TestUtilities do
    pod 'SwiftLint'
end

target :EventBus do
    pod 'SwiftLint'
end

target :Eurofurence do
	plugin 'cocoapods-acknowledgements', :settings_bundle => true
	
	pod 'Down'
	pod 'SwiftLint'
	pod 'Firebase/Core'
	pod 'Firebase/Crash'
	pod 'Firebase/Messaging'
	pod 'Firebase/Performance'
	
	pod 'SimulatorStatusMagic', :configurations => ['Screenshots']

	target :EurofurenceTests do
		inherit! :search_paths

		pod 'Firebase/Core'
		pod 'Firebase/Crash'
	end
  
  target :EurofurenceUITests do
    inherit! :search_paths
    
    pod 'Firebase/Core'
    pod 'Firebase/Crash'
  end
  
  target :ScreenshotGenerator do
    inherit! :search_paths
    
    pod 'Down'
    pod 'Firebase/Core'
    pod 'Firebase/Crash'
    pod 'Firebase/Messaging'
    pod 'Firebase/Performance'
    pod 'SimulatorStatusMagic'
  end
	
end

target :EurofurenceModel do
    
    pod 'SwiftLint'
    pod 'ReachabilitySwift'
    
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
