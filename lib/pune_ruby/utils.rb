module PuneRuby
  module Utils
    module InstanceMethods
      def sym_keys(hash)

        hash.inject({}){|result, (key, value)|

          new_key = case key
                    when String then key.to_sym
                    else key
                    end

          new_value = case value
                      when Hash then symbolize_keys_of(value)
                      else value
                      end

          result[new_key] = new_value
          result
        }
      end
    end

    def self.included(receiver)
      receiver.extend         ClassMethods
      receiver.send :include, InstanceMethods
    end
  end
end