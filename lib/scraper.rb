require 'open-uri'
require 'nokogiri'
require_relative './root.rb'
require_relative './pattern.rb'
require 'pry'

class Scraper
  BASE_URL = 'http://www.ithkuil.net/lexicon.htm'
  Html = open(BASE_URL)
  Document = load_dictionary(Nokogiri::HTML(html))
  RootMatcher = /-([BCÇČDFGHJKLĻMNŇPQRŘSŠTŢVWXYZŻŽ’]+)-/
  @@dictionary = []

  def self.search_by_phonetic_value(param)
    @@dictionary.detect{ |item| item.value.upcase == param.upcase }
  end

  private

  def self.load_dictionary(html)
    to_search = html.xpath("//table | //p")
    to_search.each do |node|
      if RootMatcher.match?(node.text)
        if node.name == 'table' 
          make_basic_root(node) 
        elsif node.parent.name == 'body'
          make_derived_root(node)
        end
      end
    end
  end

  def self.make_basic_root(node)
    rows = node.xpath('./tr | ./tbody/tr')
    definition_row = rows[0]
    phonetic_value = RootMatcher.match(definition_row.text)[1]
    translation = /‘(.*)’/.match(definition_row.text)[1]
    root = BasicRoot.new(phonetic_value, translation, get_notes(node))
    make_patterns(root, rows)
    @@dictionary << root
  end

  def self.make_derived_root(node)
    phonetic_value = RootMatcher.match(node.text)[1]
    
  end

  def self.make_patterns(root, rows)
    basic_pattern = make_basic_pattern(root, rows[(2..4)], 0, :informal, 1)
    if rows.count == 9 # #independent informal complementary stems
      complementary1 = make_basic_pattern(root, rows[(7..9)], 0, :informal, 2)
      complementary2 = make_basic_pattern(root, rows[(7..9)], 1, :informal, 3)
    else # derived complementary patterns
      complementary1 = make_derived_pattern(basic_pattern, rows[7], 0, :informal, 2)
      complementary2 = make_derived_pattern(basic_pattern, rows[7], 1, :informal, 3)
    end
    if rows[3].xpath('./td').count == 2 # independent formal patterns
      formal_pattern = make_basic_pattern(root, rows[(2..4)], 1, :formal, 1)
      if rows.count == 9 # independent formal complementary patterns
        formal_complement1 = make_basic_pattern(root, rows[(6..8)], 2, :formal, 2)
        formal_complement2 = make_basic_pattern(root, rows[(6..8)], 3, :formal, 3)
      else
        formal_complement1 = make_derived_pattern(complementary1, rows[6], 2, :formal, 2)
        formal_complement2 = make_derived_pattern(complementary2, rows[6], 3, :formal, 3)
      end
    else # formal patterns are derived
      formal_pattern = make_derived_pattern(basic_pattern, rows[2], 1, :formal, 1)
      formal_complement1 = make_derived_pattern(complementary1, rows[2], 1, :formal, 2)
      formal_complement2 = make_derived_pattern(complementary2, rows[2], 1, :formal, 3)
    end
    return nil # patterns are already associated with root now
  end

  def self.make_basic_pattern(root, rows, cell_num, designation, pattern_num)
    stems = []
    unneeded_prefix = /\d\. /
    rows.each{ |row| stems << row.xpath('./td')[cell_num].text.sub(unneeded_prefix, "") }
    BasicPattern.new(designation, pattern_num, root, stems)
  end

  def self.make_derived_pattern(basic_pattern, row, cell_num, designation, pattern_num)
    unneeded_prefix = /[Ss]ame as .+ stems,? /
    suffix = root.xpath('./td')[cell_num].text.sub(unneeded_prefix, "")
    DerivedPattern(designation, pattern_num, basic_pattern, suffix)
  end
end

# small.xpath('./tr').count == 7
# small.xpath('./tr/td').count == 10
# with_formal.xpath('./tr').count == 7
# with_formal.xpath('./tr/td').count == 15
# wtih_comp.xpath('./tr').count == 9
# with_comp.xpath('./tr/td').count == 14
# full.xpath('./tr').count == 9
# full.xpath('./tr/td').count == 23

all = doc.xpath('')