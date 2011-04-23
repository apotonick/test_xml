require 'test_xml/test_unit'

Test::Unit::TestCase.class_eval do
  def assert_not(assertion)
    assert !assertion
  end
end
