require 'ostruct'

module TestXml
  class AssertionConfig < OpenStruct
    def assert_name
      "assert_#{name}"
    end

    def assert_not_name
      "assert_not_#{name}"
    end

    def expectation
      "must_#{matcher}"
    end
  end

  ASSERTIONS = [
    AssertionConfig.new(
      :name       => :xml_contain,
      :matcher    => :contain_xml,
      :message_for_should     => lambda { |a,b| "the xml:\n#{a}\nshould contain xml:\n#{b}" },
      :message_for_should_not => lambda { |a,b| "the xml:\n#{a}\nshould not contain xml:\n#{b} but it does" }
    ),
    AssertionConfig.new(
      :name       => :xml_structure_contain,
      :matcher    => :contain_xml_structure,
      :message_for_should     => lambda { |a,b| "the xml:\n#{a}\nshould match xml structure:\n#{b}" },
      :message_for_should_not => lambda { |a,b| "the xml:\n#{a}\nshould not match xml structure:\n#{b} but it does" }
    ),
    AssertionConfig.new(
      :name       => :xml_equal,
      :matcher    => :equal_xml,
      :message_for_should     => lambda { |a,b| "the xml:\n#{a}\nshould exactly match xml:\n#{b}" },
      :message_for_should_not => lambda { |a,b| "the xml:\n#{a}\nshould not exactly match xml:\n#{b} but it does" }
    ),
    AssertionConfig.new(
      :name       => :xml_structure_equal,
      :matcher    => :equal_xml_structure,
      :message_for_should     => lambda { |a,b| "the xml:\n#{a}\nshould exactly match xml structure:\n#{b}" },
      :message_for_should_not => lambda { |a,b| "the xml:\n#{a}\nshould not exactly match xml structure:\n#{b} but it does" }
    )
  ]
end