Pod::Spec.new do |s|
  s.name         = "KWStepper"
  s.version      = "2.1.3"
  s.summary      = "A stepper control with flexible UI and tailored UX."
  s.homepage     = "https://github.com/kyleweiner/KWStepper"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "Kyle Weiner" => "kyle@kylemade.com" }
  s.screenshots  = "https://raw.githubusercontent.com/kyleweiner/KWStepper/master/screenshots.png" 
  s.source       = { :git => "https://github.com/kyleweiner/KWStepper.git", :tag => s.version }
  s.source_files = "Source/*.swift"
  s.platform     = :ios, '8.0'
  s.requires_arc = true
  s.description  = "KWStepper is a stepper control written in Swift. Unlike UIStepper, KWStepper allows for a fully customized UI and provides callbacks for tailoring the UX."
end