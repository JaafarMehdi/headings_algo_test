require "test/unit"

def header_generator(headings)
  result = ''
  previous_level = nil
  current_indexes = {}
  headings.each do |heading|
    line = ''

    heading[:heading_level].times do
      line = line + '  '
    end

    if heading[:heading_level] != previous_level
      if heading[:heading_level] < previous_level
        # reset subtree indexes
        current_indexes.keys.each do |key|
          current_indexes[key] = nil if (key > heading[:heading_level])
        end
      end
      previous_level = heading[:heading_level]
    end

    current_indexes[heading[:heading_level]] = current_indexes[heading[:heading_level]] || 0 # initialize
    current_indexes[heading[:heading_level]] += 1

    (heading[:heading_level]+1).times do |i|
      current_indexes[i] = current_indexes[i] || 1 # in case of a level jump
      line = line + current_indexes[i].to_s + '.'
    end

    line = line + ' ' + heading[:title] + "\n"
    result = result + line
  end
  result
end

class StringExtensionTest < Test::Unit::TestCase
  def test_scenario_a
    # only increases in numbers no reset
    headings = [
      {id:1, title:'heading1', heading_level: 0},
      {id:2, title:'heading2', heading_level: 2},
      {id:3, title:'heading3', heading_level: 1},
      {id:4, title:'heading4', heading_level: 1},
    ]
    puts header_generator(headings)
    assert header_generator(headings) == "1. heading1
    1.1.1. heading2
  1.2. heading3
  1.3. heading4
"
  end

  def test_scenario_b
    headings = [
      {id:1, title:'heading1', heading_level: 0},
      {id:2, title:'heading2', heading_level: 3},
      {id:3, title:'heading3', heading_level: 4},
      {id:4, title:'heading4', heading_level: 1},
      {id:5, title:'heading5', heading_level: 0},
    ]
    puts header_generator(headings)
    assert header_generator(headings) == "1. heading1
      1.1.1.1. heading2
        1.1.1.1.1. heading3
  1.2. heading4
2. heading5
"
  end

  def test_scenario_c
    headings = [
      {id:1, title:'heading1', heading_level: 0},
      {id:2, title:'heading2', heading_level: 3},
      {id:3, title:'heading3', heading_level: 4},
      {id:4, title:'heading4', heading_level: 1},
      {id:5, title:'heading5', heading_level: 3},
    ]
    puts header_generator(headings)
    assert header_generator(headings) == "1. heading1
      1.1.1.1. heading2
        1.1.1.1.1. heading3
  1.2. heading4
      1.2.1.1. heading5
"
  end
end
