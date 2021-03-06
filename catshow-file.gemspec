# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "catshow-file/version"

Gem::Specification.new do |s|
  s.name        = "catshow-file"
  s.version     = CatshowFile::VERSION
  s.authors     = ["Spike Grobstein"]
  s.email       = ["spikegrobstein@mac.com"]
  s.homepage    = ""
  s.summary     = "Catshow extensions for File"
  s.description = "Adds functionality to File for identifying TV Shows, Seasons, Episodes and their respective nfo files."
  
  s.add_dependency('nokogiri')

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
