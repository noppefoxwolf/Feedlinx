#
# Be sure to run `pod lib lint Feedlinx.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "Feedlinx"
  s.version          = "0.1.4"
  s.summary          = "Feedly API Library for iOS."
  s.description      = <<-DESC
			#Feedly API Library for iOS.
                       DESC
  s.homepage         = "https://github.com/noppefoxwolf/Feedlinx"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "hirano_tomoya" => "cromteria@gmail.com" }
  s.source           = { :git => "https://github.com/noppefoxwolf/Feedlinx.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/noppefoxwolf'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'Feedlinx' => ['Pod/Assets/*.png']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
