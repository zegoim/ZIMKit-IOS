#
# Be sure to run `pod lib lint ZIMKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ZIMKit'
  s.version          = '0.1.0'
  s.summary          = 'A short description of ZIMKit.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/wukun/ZIMKit'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'wukun' => 'wukun@zego.im' }
  s.source           = { :git => 'https://github.com/wukun/ZIMKit.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  s.source_files = 'ZIMKit/Classes/**/*'
  
  # 是否是静态库 这个地方很重要 假如不写这句打出来的包 就是动态库 不能使用 一运行会报错 image not found
  s.static_framework = true
  # 链接设置 重要
  s.xcconfig = { "OTHER_LDFLAGS" => "-ObjC", "ENABLE_BITCODE" => "NO" }
  
  s.pod_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64', 'GCC_PREPROCESSOR_DEFINITIONS[config=Debug]' => '$(inherited) _ZX_ENVIRONMENT_DEBUG_=1001', 'GCC_PREPROCESSOR_DEFINITIONS' =>
  'GPB_USE_PROTOBUF_FRAMEWORK_IMPORTS=1' }
  s.user_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }  #必须
  
  
  s.public_header_files = 'ZIMKit/Classes/**/*.h'
  
  s.prefix_header_file = 'ZIMKit/Classes/ZIMKitCommon/ZIMKitPrefix.pch'
  
  # s.resource_bundles = {
  #   'ZIMKit' => ['ZIMKit/Assets/*.png']
  # }
  s.ios.resource_bundles = {
    'ZIMKitRecources' => ['ZIMKit/Assets/ChatResources/*'],
    'ZIMKItCommon' => ['ZIMKit/Assets/CommonResources/*'],
    'ZIMKitConversation' => ['ZIMKit/Assets/ConversationResources/*']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
  
   s.dependency 'Masonry', '1.1.0'
   s.dependency 'YYText', '1.0.7'
   s.dependency 'MJRefresh', '3.1.15.3'
   s.dependency 'ZIM', '2.2.0'
end
