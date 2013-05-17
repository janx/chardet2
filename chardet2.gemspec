# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{chardet2}
  s.version = "1.0.0"

  s.authors = ["Jan Xie", "Felipe Tanus", "Hui"]
  s.autorequire = %q{UniversalDetector}
  s.date = %q{2013-05-17}
  s.email = ["jan.h.xie@gmail.com"]
  s.files = Dir["{lib}/**/*"] + ["COPYING", "README.markdown"]
  s.homepage = %q{https://github.com/janx/chardet}
  s.require_paths = ["lib"]
  s.summary = %q{Character encoding auto-detection in Ruby, compatible with 1.9/2.0. Base on Mark Pilgrim's Python port and Hui's ruby port.}
end
