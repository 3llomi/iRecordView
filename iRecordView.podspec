Pod::Spec.new do |s|
  s.name             = 'iRecordView'
  s.version          = '0.1.4'
  s.summary          = 'A Simple Audio Recorder View with hold to Record Button and Swipe to Cancel.'

  s.description      = <<-DESC
  A Simple Audio Recorder View with "hold to Record Button" and "Swipe to Cancel " Like WhatsApp
                        DESC


  s.homepage         = 'https://github.com/3llomi/iRecordView'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'AbdulAlim Rajjoub' => 'contact@devlomi.com' }
  s.source           = { :git => 'https://github.com/3llomi/iRecordView.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/3llomi'

s.ios.deployment_target = '9.0'

  s.source_files = 'Source/**/*'
  
  s.resource_bundles = {
     'iRecordView' => ['Res/**/*']
   }

s.swift_version = '5.0'


end
