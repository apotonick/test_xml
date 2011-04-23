module TestXml
  module NokogiriExt
    module Node
      def match?(element, compare_value = false)
        if compare_value && element.leaf?
          compare_with(element) and equal_text?(element) 
        else
          # non-leaf nodes:
          #TODO clean this part of the code
          if compare_value
            compare_with(element) &&
            contains_elements_of?(element) &&
            element.elements.all? {|el| matches_at_least_one?(el, compare_value) }
            
          else  # FIXME: not sure what happens here:
            contains_elements_of?(element) &&
            element.elements.all? {|el| matches_at_least_one?(el, compare_value) }
          end
        end
      end
      
      # Compares tag and and attributes with +node+.
      def compare_with(node)
        comparable_attributes == node.comparable_attributes and name == node.name
      end
      
      
      def elements
        children.collect {|node| node if node.element? }.delete_if {|node| node.nil?}
      end
      
      # Attributes of the current node.
      def comparable_attributes
        attributes.collect {|k,a| [k.downcase, a.value]}.sort
      end
      
      # Check if node is either childless, self-closing, or has content text. 
      def leaf?
        children.size == 0 or (children.size == 1 && children.first.text?)
      end

      def placeholder?
        TestXml.placeholders_enabled? and (content =~ /^`.*`$/)
      end

    private
      def equal_text?(element)
        element.content = content if element.placeholder?

        content == element.content
      end


      def contains_elements_of?(element)
        element.elements.find {|el| not contains?(el)}.nil?
      end

      def contains?(element)
        children.find {|node| node.element? && node.name == element.name }
      end

      def matches_at_least_one?(element, compare_value)
        search(element.name).find { |el| el.match?(element, compare_value) }
      end
    end
  end
end
