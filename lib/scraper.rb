require 'open-uri'
require 'nokogiri'
require_relative './root.rb'
require_relative './pattern.rb'

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
    rows = node.xpath('./tr')
    definition_row = rows[0]
    phonetic_value = RootMatcher.match(definition_row.text)[0]
    translation = /‘.*’/.match(definition_row.text)[0]
    root = BasicRoot.new(phonetic_value, translation, get_notes(node))
    make_patterns(root, node)
    @@dictionary << root
  end
end
