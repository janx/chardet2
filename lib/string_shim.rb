class String

  # slice compatible with 1.8
  def slice18(range)
  end

  def get_byte(i)
    UniversalDetector.is18? ? self[i] : bytes.to_a[i]
  end

end
