#
# Be sure to run `pod lib lint ZIMKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ZIMKit-OC'
  s.version          = '0.1.6'
  s.summary          = 'A short description of ZIMKit-OC.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/zegoim/ZIMKit-IOS'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'wukun' => 'wukun@zego.im' }
#  s.source           = { :git => 'https://github.com/zegoim/ZIMKit-IOS.git', :tag => s.version.to_s }
  s.source           = { :git => 'https://github.com/zegoim/ZIMKit-IOS.git', :tag => "#{s.version}" }
#  s.source           = { :git => '/Users/zego/Documents/IMKit/ZIMKit_CoCoPod/ZIMKit-IOS/ZIMKit'}
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

#  s.source_files = 'ZIMKit/ZIMKit/Classes/**/*'

s.subspec 'ZIMKitCommon' do |common|
    common.subspec 'ZIMKitCommonBase' do |base|
      base.source_files = 'ZIMKit/ZIMKit/Classes/ZIMKitCommon/ZIMKitCommonBase/*'
    end
    
    common.subspec 'ZIMKitRouter' do |router|
      router.source_files = 'ZIMKit/ZIMKit/Classes/ZIMKitCommon/ZIMKitRouter/*'
    end
    
    common.subspec 'ZIMKitToolUtil' do |toolUtil|
      toolUtil.source_files = 'ZIMKit/ZIMKit/Classes/ZIMKitCommon/ZIMKitToolUtil/*'
    end
end

s.subspec 'ZIMKitConversation' do |conversation|
  conversation.subspec 'Model' do |model|
    model.source_files = 'ZIMKit/ZIMKit/Classes/ZIMKitConversation/Model/*'
  end
  
  conversation.subspec 'VM' do |vm|
    vm.source_files = 'ZIMKit/ZIMKit/Classes/ZIMKitConversation/VM/*'
  end
  conversation.subspec 'UI' do |ui|
    ui.subspec 'Cell' do |cell|
      cell.source_files = 'ZIMKit/ZIMKit/Classes/ZIMKitConversation/UI/Cell/*'
    end
    ui.subspec 'Vc' do |vc|
      vc.source_files = 'ZIMKit/ZIMKit/Classes/ZIMKitConversation/UI/Vc/*'
    end
    ui.subspec 'View' do |view|
      view.source_files = 'ZIMKit/ZIMKit/Classes/ZIMKitConversation/UI/View/*'
    end
  end
end

s.subspec 'ZIMKitGroup' do |group|
  group.subspec 'Model' do |model|
    model.source_files = 'ZIMKit/ZIMKit/Classes/ZIMKitGroup/Model/*'
  end
  group.subspec 'UI' do |ui|
    ui.subspec 'Vc' do |vc|
      vc.source_files = 'ZIMKit/ZIMKit/Classes/ZIMKitGroup/UI/Vc/*'
    end
    ui.subspec 'View' do |view|
      view.source_files = 'ZIMKit/ZIMKit/Classes/ZIMKitGroup/UI/View/*'
    end
  end
  group.subspec 'VM' do |vm|
    vm.source_files = 'ZIMKit/ZIMKit/Classes/ZIMKitGroup/VM/*'
  end
end

s.subspec 'ZIMKitMessages' do |message|
  message.subspec 'Model' |model|
   model.source_files = 'ZIMKit/ZIMKit/Classes/ZIMKitMessages/Model/*'
  end
  message.subspec 'Vendor' do |vendor|
    vendor.subspec 'GKPhotoBrowser' do |photoBrowser|
      photoBrowser.source_files = 'ZIMKit/ZIMKit/Classes/ZIMKitMessages/Vendor/GKPhotoBrowser/*'
    end
  end
  message.subspec 'VM' do |vm|
    vm.source_files = 'ZIMKit/ZIMKit/Classes/ZIMKitMessages/VM/*'
  end
  
  message.subspec 'ZIMKitMessageUtil' do |messageUtil|
    messageUtil.source_files = 'ZIMKit/ZIMKit/Classes/ZIMKitMessages/ZIMKitMessageUtil/*'
  end
  
  message.subspec 'UI' do |ui|
    ui.subspec 'Cell' do |cell|
      cell.source_files = 'ZIMKit/ZIMKit/Classes/ZIMKitMessages/UI/Cell/*'
    end
    ui.subspec 'Vc' do |vc|
      vc.source_files = 'ZIMKit/ZIMKit/Classes/ZIMKitMessages/UI/Vc/*'
    end
    ui.subspec 'View' do |view|
      view.subspec 'InputView' do |inputview|
        inputview.source_files = 'ZIMKit/ZIMKit/Classes/ZIMKitMessages/UI/View/InputView/*'
      end
    end
  end
end

  # 是否是静态库 这个地方很重要 假如不写这句打出来的包 就是动态库 不能使用 一运行会报错 image not found
#  s.static_framework = true
  # 链接设置 重要
#  s.xcconfig = { "OTHER_LDFLAGS" => "-ObjC", "ENABLE_BITCODE" => "NO" }
  
#  s.pod_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64', 'GCC_PREPROCESSOR_DEFINITIONS[config=Debug]' => '$(inherited) _ZX_ENVIRONMENT_DEBUG_=1001', 'GCC_PREPROCESSOR_DEFINITIONS' =>
#  'GPB_USE_PROTOBUF_FRAMEWORK_IMPORTS=1' }
  s.user_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }  #必须
#
  s.pod_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
    
  s.prefix_header_file = 'ZIMKit/ZIMKit/Classes/ZIMKitCommon/ZIMKitCommBase/ZIMKitPrefix.pch'

# 必须要加,ZIM 不支持i386
  s.xcconfig = {
  'VALID_ARCHS' =>  'arm64 x86_64',
  }
  
  s.ios.resource_bundles = {
    'ZIMKitRecources' => ['ZIMKit/ZIMKit/Assets/ChatResources/*'],
    'ZIMKitCommon' => ['ZIMKit/ZIMKit/Assets/CommonResources/*'],
    'ZIMKitConversation' => ['ZIMKit/ZIMKit/Assets/ConversationResources/*'],
    'ZIMKitGroup' => ['ZIMKit/ZIMKit/Assets/GroupResources/*'],
    'GKPhotoBrowser' => ['ZIMKit/ZIMKit/Assets/GKPhotoBrowser/*']
  }
  
  s.ios.public_header_files = 'ZIMKit/ZIMKit/Classes/**/*.h'
  
   s.dependency 'Masonry', '1.1.0'
   s.dependency 'YYText', '1.0.7'
   s.dependency 'MJRefresh', '3.1.15.3'
   s.dependency 'TZImagePickerController', '3.8.3'
   s.dependency 'SDWebImage', '~>5.13.2'
   s.dependency 'YYWebImage', '~> 1.0.5'
   s.dependency 'ZIM', '2.3.0'
end
