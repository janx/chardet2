module UniversalDetector

  def self.is18?
    RUBY_VERSION =~ /^1\.8/
  end

end

class String

  if UniversalDetector.is18?
    alias :get_byte :[]
  else
    def get_byte(i)
      self[i].ord
    end
  end

  def to_bytes
    bytes.to_a
  end

end

class Array

  def get_byte(i)
    v = self[i]
    v = v.bytes.to_a.first if v.is_a?(String)
    v
  end

  def to_bytes
    map {|v| v.is_a?(String) ? v.get_byte(0) : v}
  end

end
