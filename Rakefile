require "rubygems"
require "rake"

require "choctop"

ChocTop.new do |s|
  # Remote upload target (set host if not same as Info.plist['SUFeedURL'])
  # s.host     = 'iflaker.com'
  s.remote_dir = 'http://github.com/macbury/iFlaker/raw/0.1/appcast.xml'

  # Custom DMG
  # s.background_file = "background.jpg"
  # s.app_icon_position = [100, 90]
  # s.applications_icon_position =  [400, 90]
  # s.volume_icon = "iflaker.icns"
   s.applications_icon = "appicon.icns" # or "appicon.png"
end
