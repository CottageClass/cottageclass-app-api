module Serializers
  class BaseSerializer
    include FastJsonapi::ObjectSerializer

    # https://github.com/Netflix/fast_jsonapi#key-transforms
    set_key_transform :underscore

    # NB fast_jsonapi supports cache settings
    # - See: https://github.com/Netflix/fast_jsonapi#caching

    def self.json_for(models, options={})
      self.new(models, options).serializable_hash
    end
  end
end
