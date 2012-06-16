# -*- encoding: utf-8 -*-
# require File.expand_path('../lib/common_engine/version', __FILE__)

Gem::Specification.new do |s|
  s.name = %q{chardet}
  s.version = "0.9.0"
  s.required_rubygems_version = nil if s.respond_to? :required_rubygems_version=
  s.authors = ["Hui"]
  s.autorequire = %q{UniversalDetector}
  # s.cert_chain = nil
  s.date = %q{2006-03-28}
  s.email = %q{zhengzhengzheng@gmail.com}  
  s.files = `git ls-files`.split($\)
  s.homepage = %q{http://blog.vava.cn/}
  s.require_paths = ["lib"]
  s.required_ruby_version = Gem::Requirement.new("> 0.0.0")
  s.rubygems_version = %q{1.5.2}
  s.summary = %q{Character encoding auto-detection in Ruby. Base on Mark Pilgrim's Python port.}

  if s.respond_to? :specification_version then
    s.specification_version = 1

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
