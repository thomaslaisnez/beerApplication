# Uncomment the next line to define a global platform for your project
platform :ios, '8.0'

target 'beerApplication' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for beerApplication
  pod 'Alamofire', '~> 4.3'
  pod 'SwiftyJSON'
  pod 'RealmSwift'

  post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['SWIFT_VERSION'] = '3.0'
      end
    end
  end

end
