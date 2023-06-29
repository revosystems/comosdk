Pod::Spec.new do |spec|

  spec.name         = "ComoSdk"
  spec.version      = "0.1.18"
  spec.summary      = "Library to connect to como loyalty."

  spec.description  = "A library that handles the connection and flow to como loyalty"

  spec.homepage     = "https://revo.works"

  spec.license      = "MIT"
  # spec.license      = { :type => "MIT", :file => "FILE_LICENSE" }

  spec.swift_version = "5.3"

  spec.author             = { "Jordi Puigdellívol" => "jordi@gloobus.net" }
  # Or just: spec.author    = "Jordi Puigdellívol"
  # spec.authors            = { "Jordi Puigdellívol" => "jordi@gloobus.net" }
  spec.social_media_url   = "https://instagram.com/badchoice2"

  # spec.platform     = :ios
   #spec.platform     = :ios, "9.3"

  #  When using multiple platforms
   spec.ios.deployment_target = "13.0"


  spec.source       = { :git => "https://github.com/revosystems/comosdk.git", :tag => spec.version.to_s }


  spec.source_files  = "ComoSdk/src/**/*.{swift}"#, "src/**/*.{h,m}"
  #spec.exclude_files = "Classes/Exclude"

  # spec.public_header_files = "Classes/**/*.h"


  # spec.resource  = "icon.png"
  spec.resources = "ComoSdk/resources/*.*"

  # spec.preserve_paths = "FilesToSave", "MoreFilesToSave"



  # spec.requires_arc = true

  # spec.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
   spec.dependency "RevoHttp", "~> 0.3.2"
   spec.dependency "RevoUIComponents", "~> 0.0.32"

end
