#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint byteplus_effects_plugin.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'byteplus_effects_plugin'
  s.version          = '0.0.1'
  s.summary          = 'BytePlus Effects Plugin'
  s.description      = <<-DESC
BytePlus Effects Plugin
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.platform = :ios, '10.0'
  
  s.dependency 'Masonry', '1.1.0'
  s.dependency 'KVOController', '1.2.0'
  s.dependency 'Toast', '4.0.0'
  s.dependency 'Mantle', '2.1.0'
  s.dependency 'TZImagePickerController', '3.6.2'
  s.dependency 'ZLPhotoBrowser', '3.0.7'
  s.dependency 'DGActivityIndicatorView', '2.1.1'
  s.dependency 'LMJDropdownMenu'
  s.dependency 'AFNetworking', '~> 3.2.1'
  s.dependency 'SSZipArchive'
  s.dependency 'YYModel'
  s.dependency 'SDWebImage'
  
  s.static_framework = true
  
#  s.preserve_paths = 'Frameworks/effect-sdk.framework'
#  s.xcconfig = { 'OTHER_LDFLAGS' => '-framework effect-sdk' }
#  s.vendored_frameworks = 'Frameworks/effect-sdk.framework'

#  s.resources = 'Assets/**/*'
#  s.resources = ['Assets/**.*']

  # Flutter.framework does not contain a i386 slice.
#  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
end
