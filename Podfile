# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '10.0'
inhibit_all_warnings!

target 'AgroPartnerships' do

use_frameworks!

    pod 'Alamofire', '~> 4.5'
    pod 'MBProgressHUD', '~> 1.1.0'
    pod 'EVReflection/Alamofire'
    pod 'IQKeyboardManagerSwift'
    pod 'DropDown'
    pod 'Toast-Swift', '~> 3.0.1'
    pod 'Kingfisher', '~> 5.0'
    pod 'Paystack'
    pod 'SwiftyJSON', '~> 4.0'
    pod 'SwiftyOnboard'
    pod 'Cards'
    pod 'FittedSheets'
    pod 'Firebase/Analytics'
    pod 'Firebase/Messaging'
    pod 'KeychainAccess'
    pod 'FacebookCore'
    pod 'FacebookLogin'
    pod 'FacebookShare'
    pod "ExpandableLabel"

end

post_install do |installer|
    installer.pods_project.build_configurations.each do |config|
        config.build_settings.delete('CODE_SIGNING_ALLOWED')
        config.build_settings.delete('CODE_SIGNING_REQUIRED')
    end
end
