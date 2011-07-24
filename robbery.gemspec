# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "robbery/version"

Gem::Specification.new do |s|
  s.name        = "robbery"
  s.version     = Robbery::VERSION
  s.authors     = ["Mike Bethany"]
  s.email       = ["mikbe.tk@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{The Great Train Robbery}
  s.description = %q{Card Game engine - play a gan leader robbing trains or be the lone Pinkerton detective tasked with protecting all the trains.}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {spec}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
