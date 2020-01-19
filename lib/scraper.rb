require 'open-uri'
require 'nokogiri'
require_relative './root.rb'
require_relative './pattern.rb'

class Scraper
  # BASE_URL = 'http://www.ithkuil.net/lexicon.htm'
  # Html = open(BASE_URL)
  RootMatcher = /-([BCÇČDFGhHJKLĻMNŇPQRŘSŠTŢVWXYZŻŽ’]+)-/
  @@dictionary = []
  @@errs = []
  @@errs2 = []

  def self.search_by_phonetic_value(param)
    unless param.nil?
      return @@dictionary.detect{ |root| root.value.upcase.gsub("’", "'") == param.upcase.gsub("’", "'") }
    end
    nil
  end

  def self.search_by_translation(param)
    result = { translation_eq: [], stems_eq: [], translation_contains: [], stems_contain: [] }
    @@dictionary.each do |root|
      search_result = root.search(param.downcase)
      if search_result.is_a?(Array)
        search_result[0].stems.any?{|stem| stem.downcase == param.downcase} ? result[:stems_eq] << search_result[0] : result[:stems_contain] << search_result[0]
      elsif search_result.nil? == false
        begin
          search_result.translation == param.downcase ? result[:translation_eq] << search_result : result[:translation_contains] << search_result
        rescue
          binding.pry
        end
      end
    end
    result
  end

  def self.load_dictionary # (html)
    base_url = 'http://www.ithkuil.net/lexicon.htm'
    html = Nokogiri::HTML(open(base_url))
    html.xpath('/html/body/table').each{ |node| make_basic_root(node) if node.text.match?(RootMatcher) }
    html.xpath('/html/body/p').each{ |node| make_derived_root(node) if node.text.match?(RootMatcher) }
  end

  def self.make_basic_root(node)
    rows = node.xpath('./tr | ./tbody/tr')
    definition_row = rows[0]
    phonetic_value = definition_row.text.match(RootMatcher)[1]
    translation = definition_row.text.match(/‘(.*?)’/)
    if translation.nil?
      begin
        translation = definition_row.text.match(/-\s+‘?(.*)\r$/)[1]
      rescue
        translation = detect_oddballs_basic(phonetic_value)
      end
    else
      translation = translation[1]
    end
    root = BasicRoot.new(phonetic_value, translation)
    make_patterns(root, rows)
    @@dictionary << root
  end

  def self.detect_oddballs_basic(phonetic_value)
    definitions_hash = {
      "FY" => "EIGHT",
      "KR" => "TOOL/INSTRUMENT",
      "KSS" => "HADRONS (COMPOSITE FERMIONS OR COMPOSITE BOSONS)",
      "KT’" => "PRESSURE-BASED or REACTION-BASED or GRAVITATION-BASED EQUILIBRIUM/MOTION/PROPULSION",
      "KTh" => "ATOM / NUCLEUS / ELECTRON CLOUD",
      "LB" => "DIMENSIONAL/SPATIO-TEMPORAL RELATIONS",
      "ŇKY" => "ELEMENTARY PARTICLES/FORCES OF PHYSICS (FERMIONS & BOSONS)",
      "P" => "[The CARRIER Root – see Section 9.3]",
      "TXh" => "SUBATOMIC PARTICLE"
    }
    definitions_hash[phonetic_value]
  end

  def self.make_derived_root(node)
    split_text = node.text.split(RootMatcher)
    phonetic_value = split_text[1]
    begin
      translation = split_text[2].sub(/(?:w\/ )?(?:the)? stems .+root/i, "")
      basic_root = search_by_phonetic_value(split_text[3])
      root = DerivedRoot.new(phonetic_value, translation, basic_root)
      @@dictionary << root
    rescue
      begin
        return nil if node.text.start_with?("Note ")
        definitions_array = detect_oddballs_derived(node.text)
        phonetic_value = definitions_array[0]
        translation = definitions_array[1]
        basic_root = search_by_phonetic_value(definitions_array[2])
      rescue
        binding.pry
        @@errs << node.text
      end
    end
  end

  def self.detect_oddballs_derived(row_text)
    definitions_hash = {
      "\r\n-ČP'-" => ["ČP'","glass (material)", "XL"],
      "LC’-" => ["LC’", "PLANARITY/FLATNESS RELATIVE TO OBJECT ITSELF", "LB"],
      "-BD-" => ["BD", "NECKTIE/CRAVATTE", "GV"],
      "-DDR-" => ["DDR", "mental disorder (i.e., no discernible  lesion)", "SXh"],
      "-KSP" => ["KSP", "-X/+Y/+Z SPATIAL ORIENTATION/POSITION/DIRECTION", "F"],
      " -PSK" => ["PSK", "-X/+Y/-Z SPATIAL ORIENTATION/POSITION/DIRECTION", "F"],
      "-RDhW" => ["GULL", "SK"],
      "-RĻ-" => ["RĻ", "SPIRAL VECTOR MOTION (i.e., corkscrew motion with increasing or decreasing  amplitude)", "K"],
      "-RZ-" => ["RZ", "3-DIMENSIONAL EXTERNAL CIRCUMLATIVE MOTION / MOVEMENT AROUND/ALONG PERIPHERY OR SURFACE OF", "K"],
      "-ŘThW" => ["ŘThW", "OSTRICH", "SK"],
      "-ŘZW" => ["ŘZW", "BISON/BUFFALO", "SK"],
      "-SQ -" => ["SQ", "cook (= prepare food using heat)", "SX"],
      "-VGY-" => ["VGY", "acetone", "XL"],
      "-XhTW-" => ["XhTW", "tobacco (plant/leaves of sp. Nicotiana tabacum)", "QW"]
    }
    definitions_hash.each{ |key, array| return array if row_text.start_with?(key) }
    nil
  end

  def self.make_patterns(root, rows)
    basic_pattern = make_basic_pattern(root, rows[(2..4)], 0, :informal, 1)
    if rows.count == 9 && root.value != "RV" # independent informal complementary stems
      complementary1 = make_basic_pattern(root, rows[(6..8)], 0, :informal, 2)
      complementary2 = make_basic_pattern(root, rows[(6..8)], 1, :informal, 3)
    else # derived complementary patterns
      complementary1 = make_derived_pattern(basic_pattern, rows[6], 0, :informal, 2)
      complementary2 = make_derived_pattern(basic_pattern, rows[6], 1, :informal, 3)
    end
    if rows[3].xpath('./td').count == 2 # independent formal patterns
      formal_pattern = make_basic_pattern(root, rows[(2..4)], 1, :formal, 1)
      if rows.count == 9 && rows[8].xpath('./td').count == 4 # independent complementary formal patterns
        formal_complement1 = make_basic_pattern(root, rows[(6..8)], 2, :formal, 2)
        formal_complement2 = make_basic_pattern(root, rows[(6..8)], 3, :formal, 3)
      elsif rows.count == 9 && rows[8].xpath('./td').count == 2 # derived from formal pattern 1
        formal_complement1 = make_derived_pattern(formal_pattern, rows[6], 2, :formal, 2)
        formal_complement2 = make_derived_pattern(formal_pattern, rows[6], 3, :formal, 3)        
      else # derived from informal complementary patterns
        formal_complement1 = make_derived_pattern(complementary1, rows[6], 2, :formal, 2)
        formal_complement2 = make_derived_pattern(complementary2, rows[6], 3, :formal, 3)
      end
    else # all formal patterns are derived
      formal_pattern = make_derived_pattern(basic_pattern, rows[2], 1, :formal, 1)
      formal_complement1 = make_derived_pattern(complementary1, rows[2], 1, :formal, 2)
      formal_complement2 = make_derived_pattern(complementary2, rows[2], 1, :formal, 3)
    end
    return nil # patterns are already associated with root now
  end

  def self.make_basic_pattern(root, rows, cell_num, designation, pattern_num)
    stems = []
    unneeded_prefix = /\d\. /
    rows.each do |row| 
      begin
        stems << row.xpath('./td')[cell_num].text.sub(unneeded_prefix, "")
      rescue
        binding.pry
      end
    end
    BasicPattern.new(designation, pattern_num, root, stems)
  end

  def self.make_derived_pattern(basic_pattern, row, cell_num, designation, pattern_num)
    unneeded_prefix = /[Ss]ame as .+ stems,? /
    suffix = row.xpath('./td')[cell_num].text.sub(unneeded_prefix, "")
    DerivedPattern.new(designation, pattern_num, basic_pattern, suffix)
  end
end