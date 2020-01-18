require 'open-uri'
require 'nokogiri'
require_relative './root.rb'
require_relative './pattern.rb'
require 'pry'

class Scraper
  BASE_URL = 'http://www.ithkuil.net/lexicon.htm'
  Html = open(BASE_URL)
  Document = load_dictionary(Nokogiri::HTML(html))
  RootMatcher = /-[BCÇČDFGHJKLĻMNŇPQRŘSŠTŢVWXYZŻŽ’]+-/
  @@dictionary = []

  def self.load_dictionary(html)
    to_search = html.xpath("//table | //p")
    to_search.each do |node|
      root_word = RootMatcher.match(node.text)
      unless root_word.nil?
        node.name == 'table' ? make_basic_root(node) : make_derived_root(node)
      end
    end
  end

  def self.make_basic_root(node)
    rows = node.xpath('./tr | ./tbody/tr')
    definition_row = rows[0]
    phonetic_value = RootMatcher.match(definition_row.text)[0]
    translation = /‘.*’/.match(definition_row.text)[0]
    root = BasicRoot.new(phonetic_value, translation, get_notes(node))
    make_patterns(root, rows)
    @@dictionary << root
  end

  def self.make_patterns(root, rows)
    
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