require 'yaml'
module DataSpec
  module Refinements
    refine Array do
      def tree_walk_with_self &block  
        self.each_with_index do |element, index|
          if element.is_a?(Hash) || element.is_a?(Array)
            element.tree_walk_with_self &block
          else
            yield [index, element], self    
          end
        end
      end

      def deep_include? sub_array
        (sub_array - self).empty?
      end
    end
        
    refine Hash do               
      def tree_walk_with_self &block  
        self.each do |key, value| 
          if value.is_a?(Hash) || value.is_a?(Array)
            value.tree_walk_with_self &block
          else
            yield [key, value], self         
          end
        end
      end                        

      #TODO: Can I replace this with a block passed to Tree Walker?
      def deep_include?(sub_hash)
        sub_hash.keys.all? do |key|
          self.has_key?(key) && if sub_hash[key].is_a?(Hash)
            self[key].is_a?(Hash) && self[key].deep_include?(sub_hash[key])
          else
            self[key] == sub_hash[key]
          end
        end
      end
    end
  end
end

using DataSpec::Refinements              
module DataSpec
  module Helpers             
    def self.evaluate string
      eval(string)
    end
    def self.parse yaml
      # `code` is more readable, but not parsable, for our purposes we're converting it to $
      unrendered = YAML.load(yaml.gsub("`", "$"))
    
      if unrendered.is_a?(Array) || unrendered.is_a?(Hash)
        rendered = unrendered.tree_walk_with_self do |(k, v), h|
          if v =~ /^\$(.+)\$$/     
            h[k] = self.evaluate($1)        
          end
        end
      elsif unrendered.is_a?(String) && unrendered =~ /^\$(.+)\$$/
        rendered = self.evaluate($1)
      else
        rendered = unrendered
      end
      rendered
    end
    def self.at_path data, path
      return data if path.nil? || path.empty?
      path.split('/').each do |key| 
        key = key.to_i if data.is_a? Array
        data = data[key] || data[key.to_sym]
      end  
      data
    end
  end
  def self.parse string
    DataSpec::Helpers.parse(string)
  end
end
