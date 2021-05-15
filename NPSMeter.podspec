#
# Be sure to run `pod lib lint NPSMeter.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'NPSMeter'
  s.version          = '0.1.0'
  s.summary          = 'A short description of NPSMeter.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/npsmeter/NPSMeter'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'npsmeter' => 'yangchuang@npsmeter.cn' }
  s.source           = { :git => 'https://github.com/npsmeter/npsmeter_sdk_ios.git', :tag => s.version.to_s }

  s.swift_version = '5.4'

  s.ios.deployment_target = '12.0'

  s.source_files = 'NPSMeter/Classes/**/*'
  
  s.resource_bundles = {
    'NPSMeter' => ['NPSMeter/Assets/**']
  }


  s.dependency 'Alamofire','~>5.4.3' #网络请求
  s.dependency 'SwiftyJSON','~>5.0.1' # json处理
  s.dependency 'HandyJSON','~>5.0.2'
  s.dependency 'SnapKit','~>5.0.1' #自动布局
  s.dependency 'RxSwift','~>6.1.0'
  s.dependency 'RxCocoa','~>6.1.0'
  s.dependency 'IQKeyboardManagerSwift','~>6.5.6'
  s.dependency 'PKHUD','~>5.3.0'
  s.dependency 'SwiftSVG','~>2.3.2'
end
