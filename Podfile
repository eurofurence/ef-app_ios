# Dependency management for the Eurofurence app
platform :ios, '9.0'
inhibit_all_warnings!
use_frameworks!

target 'Eurofurence' do
	pod 'Alamofire', '~> 4.5'
	pod 'AlamofireImage', '~> 3.0'
	pod 'Changeset'
	pod 'Dip'
	pod 'Dip-UI'
	pod 'Eureka', :git => 'https://github.com/xmartlabs/Eureka.git'
	pod 'EVReflection'
	pod 'EVReflection/Alamofire'
	pod 'SwiftLint'
	pod 'ReachabilitySwift', :git => 'https://github.com/ashleymills/Reachability.swift'
	pod 'ReactiveSwift', '~> 1.1'
	pod 'ReactiveCocoa', '~> 5.0.0'
	pod 'Firebase/Core'
	pod 'Firebase/Crash'
    pod 'Firebase/Messaging'
    pod 'Locksmith'

    target :EurofurenceTests do
        inherit! :search_paths

        pod 'Firebase/Core'
        pod 'Firebase/Crash'
    end
end
