# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{autosub}
  s.version = "0.2.4"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["Pirate"]
  s.date = %q{2009-02-10}
  s.default_executable = %q{autosub}
  s.description = %q{Ruby tool to automatically download subtitles (srt) inside your TV Shows folder}
  s.email = %q{pirate.2061@gmail.com}
  s.executables = ["autosub"]
  s.extra_rdoc_files = ["bin/autosub", "lib/episode.rb", "lib/inspector.rb", "lib/sites/seriessub.rb", "lib/sites/tvsubtitle.rb", "README.markdown"]
  s.files = ["asset/failure.png", "asset/srt.png", "autosub.gemspec", "bin/autosub", "lib/episode.rb", "lib/inspector.rb", "lib/sites/seriessub.rb", "lib/sites/tvsubtitle.rb", "Manifest", "Rakefile", "README.markdown"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/pirate/autosub}
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Autosub", "--main", "README.markdown"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{autosub}
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{Ruby tool to automatically download subtitles (srt) inside your TV Shows folder}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<hpricot>, [">= 0"])
      s.add_runtime_dependency(%q<rubyzip>, [">= 0"])
      s.add_runtime_dependency(%q<optiflag>, [">= 0"])
      s.add_runtime_dependency(%q<simple-rss>, [">= 0"])
      s.add_runtime_dependency(%q<mechanize>, [">= 0"])
    else
      s.add_dependency(%q<hpricot>, [">= 0"])
      s.add_dependency(%q<rubyzip>, [">= 0"])
      s.add_dependency(%q<optiflag>, [">= 0"])
      s.add_dependency(%q<simple-rss>, [">= 0"])
      s.add_dependency(%q<mechanize>, [">= 0"])
    end
  else
    s.add_dependency(%q<hpricot>, [">= 0"])
    s.add_dependency(%q<rubyzip>, [">= 0"])
    s.add_dependency(%q<optiflag>, [">= 0"])
    s.add_dependency(%q<simple-rss>, [">= 0"])
    s.add_dependency(%q<mechanize>, [">= 0"])
  end
end
