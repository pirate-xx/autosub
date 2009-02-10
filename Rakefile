# Rakefile
require 'rubygems'
require 'rake'
require 'echoe'

Echoe.new('autosub', '0.2.5') do |p|
  p.description    = "Ruby tool to automatically download subtitles (srt) inside your TV Shows folder"
  p.url            = "http://github.com/pirate/autosub"
  p.author         = "Pirate"
  p.email          = "pirate.2061@gmail.com"
  p.ignore_pattern = ["tmp/*", "script/*"]
  p.executable_pattern = "bin/autosub"
  p.runtime_dependencies = ["hpricot", "rubyzip", "optiflag", "simple-rss", "mechanize"]
end

Dir["#{File.dirname(__FILE__)}/tasks/*.rake"].sort.each { |ext| load ext }