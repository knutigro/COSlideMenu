#
# Be sure to run `pod lib lint COSlideMenuDemo.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "COSlideMenu"
  s.version          = "0.0.1"
  s.summary          = "Swift implementation of a sliding menu"
  s.description      = <<-DESC
                        Swift implementation of a sliding menu.
                        DESC
  s.homepage         = "https://github.com/knutigro/COSlideMenu"
  s.license          = 'MIT'
  s.author           = { "Knut Inge Grosland" => "”hei@knutinge.com”" }
  s.source           = { :git => "https://github.com/knutigro/COSlideMenu.git", :tag => s.version }

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'COSlideMenu/*.swift'

end
