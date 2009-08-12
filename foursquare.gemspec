# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{foursquare}
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Brandon Keene"]
  s.date = %q{2009-08-20}
  s.description = %q{Ruby API for Foursquare (playfoursquare.com)}
  s.email = %q{bkeene@gmail.com}
  s.extra_rdoc_files = ["LICENSE"]
  s.files = ["README", "LICENSE", "lib/foursqaure.rb",]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/cmdrkeene/foursquare}
  s.rdoc_options = ["--inline-source", "--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubyforge_project = nil
  s.rubygems_version = %q{1.3.0}
  s.summary = %q{Ruby API for Foursquare (playfoursquare.com)}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 1

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<httparty>, [">= 0.4.4"])
    else
      s.add_dependency(%q<httparty>, [">= 0.4.4"])
    end
  else
    s.add_dependency(%q<httparty>, [">= 0.4.4"])
  end
end