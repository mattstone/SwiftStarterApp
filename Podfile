# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'StarterProject' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for StarterProject


  pod 'SVProgressHUD', :git => 'https://github.com/SVProgressHUD/SVProgressHUD.git'
  pod 'Colours'

  pod 'Firebase/Core'   # Google Firebase analytics
  pod 'Fabric', '~> 1.9.0'
  pod 'Crashlytics', '~> 3.12.0'
  pod 'RealmSwift'

  post_install do |installer|
    puts("Update debug pod settings to speed up build time")
    Dir.glob(File.join("Pods", "**", "Pods*{debug,Private}.xcconfig")).each do |file|
        File.open(file, 'a') { |f| f.puts "\nDEBUG_INFORMATION_FORMAT = dwarf" }
    end
  end


end
