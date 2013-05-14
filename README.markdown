About
=====

This is a ruby 1.9/2.0 compatible version of chardet on http://rubyforge.org/projects/chardet/

Usage
=====

```
irb(main):001:0> require 'rubygems'
=> true
irb(main):002:0> require 'UniversalDetector'
=> false
irb(main):003:0> p UniversalDetector::chardet('hello')
{"encoding"=>"ascii", "confidence"=>1.0}
=> nil
```

Contributors
============

[Felipe Tanus](https://github.com/fotanus)
