class NilClass
  def to_bool
    false
  end
end

class String
  def to_bool
    self.downcase == 'true' || self == '1'
  end
end