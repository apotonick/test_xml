require 'test_helper'

class TestNode < Test::Unit::TestCase
  def test_elements
    assert doc.elements.size == 1
    assert doc.at('root').elements.size == 2
  end
  
  def test_leaf?
    assert root("<a/>").leaf?
    assert root("<a>Yo</a>").leaf?
    assert root("<a></a>").leaf?
    assert !root("<div><a/></div>").leaf?
  end
  
  def test_compare_with?
    assert root("<a/>").compare_with(root("<a/>"))
    assert root(%{<a rel="self"/>}).compare_with(root(%{<a rel="self"/>}))
    
    assert_not root("<a/>").compare_with(root("<div/>"))
    assert_not root(%{<a rel="self"/>}).compare_with(root(%{<a rel="next"/>}))
  end
  
  def test_equal?
    assert root("<div><a/></div>").equal?(root("<div>
      <a/></div>"))
  end
  
  
  

  def test_match_of_elements_without_comparing_values
    subject = root(<<-XML)
      <root>
        <one>1</one>
        <two>
          <three>3</three>
        </two>
      </root>
    XML

    pattern = root(<<-XML)
      <root>
        <two><three/></two>
        <one>2</one>
      </root>
    XML

    assert subject.match?(pattern)
  end

  def test_no_match_of_elements_without_comparing_values
    subject = root(<<-XML)
      <root>
        <one>1</one>
        <two/>
      </root>
    XML

    pattern = root(<<-XML)
      <root>
        <four/>
        <five>5</five>
      </root>
    XML

    assert !subject.match?(pattern)
  end

  def test_match_with_values
    subject = root(<<-XML)
      <root>
        <one>1</one>
        <two><three>3</three></two>
      </root>
    XML

    pattern = root(<<-XML)
      <root>
        <two><three>3</three></two>
        <one>1</one>
      </root>
    XML

    assert subject.match?(pattern, true)
  end

  def test_no_match_with_values
    subject = root(<<-XML)
      <root>
        <one>1</one>
      </root>
    XML

    not_matched_pattern = root(<<-XML)
      <root>
        <one>2</one>
      </root>
    XML

    assert !subject.match?(not_matched_pattern, true)
  end

  def test_element_contains_another_element
    element = create_element('<one/>')

    assert !doc.send(:contains?,element)
    assert doc.at('root').send(:contains?,element)
  end
  
  def test_element_contains_elements
    assert doc.root.send(:contains_elements_of?, doc.root)
    assert !doc.root.send(:contains_elements_of?, doc('<root><test_element/></root>'))
  end
  
  def test_comparable_attributes
    assert_equal [["id", "boss"], ["name", "Dude"]], root(%{<li name="Dude" id="boss" />}).comparable_attributes
    
    assert_equal [["name", "Dude"]], root(%{<li NAME="Dude"/>}).comparable_attributes
  end
  
  def test_comparable_children
    assert_equal ["li"], root(%{<ul>
    
          <li/></ul>}).comparable_children.collect { |n| n.name }
  end
  

  private
  
  def create_element(xml)
    Nokogiri::XML::Document.parse(xml).root
  end

  def root(xml)
    doc(xml).root
  end

  def doc(xml = nil)
    xml ||= <<-XML
      <root>
        <one>1</one>
        <two>2</two>
      </root>
    XML
    Nokogiri::XML::Document.parse(xml)
  end
end
