# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{chardet}
  s.version = "0.9.0"

  s.required_rubygems_version = nil if s.respond_to? :required_rubygems_version=
  s.authors = ["Hui"]
  s.autorequire = %q{UniversalDetector}
  s.cert_chain = nil
  s.date = %q{2006-03-28}
  s.email = %q{zhengzhengzheng@gmail.com}
  s.files = ["lib/Big5Freq.rb", "lib/Big5Prober.rb", "lib/CharDistributionAnalysis.rb", "lib/CharSetGroupProber.rb", "lib/CharSetProber.rb", "lib/CodingStateMachine.rb", "lib/EscCharSetProber.rb", "lib/ESCSM.rb", "lib/EUCJPProber.rb", "lib/EUCKRFreq.rb", "lib/EUCKRProber.rb", "lib/EUCTWFreq.rb", "lib/EUCTWProber.rb", "lib/GB2312Freq.rb", "lib/GB2312Prober.rb", "lib/HebrewProber.rb", "lib/JapaneseContextAnalysis.rb", "lib/JISFreq.rb", "lib/LangBulgarianModel.rb", "lib/LangCyrillicModel.rb", "lib/LangGreekModel.rb", "lib/LangHebrewModel.rb", "lib/LangHungarianModel.rb", "lib/LangThaiModel.rb", "lib/Latin1Prober.rb", "lib/MBCSGroupProber.rb", "lib/MBCSSM.rb", "lib/MultiByteCharSetProber.rb", "lib/SBCSGroupProber.rb", "lib/SingleByteCharSetProber.rb", "lib/SJISProber.rb", "lib/UniversalDetector.rb", "lib/UTF8Prober.rb", "python-docs/css", "python-docs/faq.html", "python-docs/how-it-works.html", "python-docs/images", "python-docs/index.html", "python-docs/license.html", "python-docs/supported-encodings.html", "python-docs/usage.html", "python-docs/css/chardet.css", "python-docs/images/caution.png", "python-docs/images/important.png", "python-docs/images/note.png", "python-docs/images/permalink.gif", "python-docs/images/tip.png", "python-docs/images/warning.png", "COPYING", "README"]
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
