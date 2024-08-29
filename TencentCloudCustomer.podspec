#
# Be sure to run `pod lib lint TencentCloudCustomer.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'TencentCloudCustomer'
  s.version          = '1.1.0'
  s.summary          = 'Tencent Cloud Smart Customer Service UIKit on Customer Side.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!


  s.description      = 'Tencent Cloud Desk, leveraging Tencent\'s extensive experience in instant messaging and artificial intelligence, offers an all-in-one customer service solution for businesses. You can seamlessly integrate this AI-based customer service system into your corporate website, mobile apps, and Wechat mini-programs, enhancing the efficiency of services provided to your users. Furthermore, built on the robust Tencent Cloud Chat platform, Desk provides developers with advanced Instant Messaging capabilities and open APIs, enabling tailored solutions to meet specific business requirements.'

  s.homepage         = 'https://desk.qcloud.com/'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Tencent Cloud Desk' => '814209329@qq.com' }
  s.swift_version = '5.0'
  s.source           = { :git => 'https://github.com/RoleWong/tencent_cloud_customer_ios', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'
  
  
  s.vendored_frameworks = 'OpenTelemetry.framework'
  
  s.dependency 'TDeskCore'
  s.dependency 'TDeskCommon'
  s.dependency 'TDeskChat'
  s.dependency 'TDeskCustomerServicePlugin'
#  s.dependency 'OpenTelemetry'

  s.frameworks = 'UIKit', 'Foundation'
  s.source_files = ['TencentCloudCustomer/Classes/**/*', 'OpenTelemetry/Classes/**/*']
  s.public_header_files = ['TencentCloudCustomer/Classes/**/*.h', 'OpenTelemetry/Classes/**/*.h']
#  s.source_files = 'TencentCloudCustomer/Classes/**/*'
#  s.public_header_files = 'TencentCloudCustomer/Classes/**/*.h'
  
  s.resource = ['Resources/*.bundle']
  

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end

