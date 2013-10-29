Pod::Spec.new do |s|
  s.name         = "MTRandom"
  s.version      = "0.0.1"
  s.summary      = "Objective-C wrapper for Mersenne Twister, a (pseudo) random number generator."
  s.homepage     = "https://github.com/preble/MTRandom"
  s.license      = 'MIT'
  s.author       = "Adam Preble"
  s.platform     = :ios
  s.source       = { :git => "https://github.com/preble/MTRandom.git", :commit => "a8de1fa1a7f5e7954685b4b50ba6090c9516ba5f" }
  s.source_files  = 'MTRandom/MTRandom.{h,m}'
  s.requires_arc = true
end
