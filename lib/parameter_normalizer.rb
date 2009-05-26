
module ParameterNormalizer
 
  def self.normalize(value)
    value.kind_of?(Hash) ? normalize_references(value) : value
  end
  
  private
  
  def self.normalize_references(hash)
    hash.inject({}) do |normalized, (key, value)|
      case value
      when Hash
        if ref = value.delete('$ref')
          normalized["#{key}_id"] = normalize_id(ref)
        else
          normalized[key] = normalize_references(value)
        end
      else
        normalized[key] = value
      end
      normalized
    end
  end
  
  def self.normalize_id(ref)
    ref.sub(%r{^.*/}, '')
  end
end
