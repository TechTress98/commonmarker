# frozen_string_literal: true

require "test_helper"

class TestTasklists < Minitest::Test
  def setup
    text = <<-MD
 - [x] Add task list
 - [ ] Define task list
    MD
    @html = Commonmarker.to_html(text, :DEFAULT, [:tasklist])
    @expected = <<~HTML
      <ul>
      <li><input type="checkbox" checked="" disabled="" /> Add task list</li>
      <li><input type="checkbox" disabled="" /> Define task list</li>
      </ul>
    HTML
    @doc = Nokogiri::HTML(@html)
  end

  def test_to_html
    assert_equal(@expected, @html)
  end

  def test_tasklist_state
    list = @doc.first_child
    assert_equal("checked", list.first_child.tasklist_state)
    assert_predicate(list.first_child, :tasklist_item_checked?)
    assert_equal("unchecked", list.first_child.next.tasklist_state)
    refute_predicate(list.first_child.next, :tasklist_item_checked?)
  end

  def test_set_tasklist_state
    list = @doc.first_child
    list.first_child.tasklist_item_checked = false
    refute_predicate(list.first_child, :tasklist_item_checked?)
    list.first_child.next.tasklist_item_checked = true
    assert_predicate(list.first_child.next, :tasklist_item_checked?)
  end
end
