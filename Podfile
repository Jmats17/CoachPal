# Uncomment this line to define a global platform for your project
# platform :ios, '9.0'

source 'https://github.com/CocoaPods/Specs.git'
use_frameworks!


target 'CoachPal' do
  # Comment this line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!
  # Pods for CoachPal
  pod 'RealmSwift’, '~> 2.0.2'
 pod 'Eureka', '~> 2.0'
pod 'ImageRow', '~> 1.0'
post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '3.0'
    end
  end
 end
end
