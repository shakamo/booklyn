require 'active_support/concern'

module GooLabs
  extend ActiveSupport::Concern

  @@pass_list = %w[畳間]

  def call_morph(target_string)
    url = URI.parse('http://labs.goo.ne.jp/api/morph')
    req = Net::HTTP::Post.new(url.path)
    req.set_form_data({"app_id" => "9f44e0022e49a2414c19d0689a687c44b0e85d603219e4f7042b6d57a668d678","sentence" => target_string}, ';')

    http = Net::HTTP.new(url.host, 443)
    http.use_ssl = true
    res = http.start do |http| 
      http.request(req) 
    end

    json = JSON.parse(res.body, {:symbolize_names => true})

    morph = {
      :raw => Array.new,
      :morph => Array.new,
      :kana => Array.new
    }

    json[:word_list].each do |word_list|
      word_list.each do |word|
        morph[:raw] << word[0]
        morph[:morph] << word[1]
        morph[:kana] << word[2]
      end
    end

    return morph
  end

  def call_trim_morph(target_string)
    morph = call_morph(target_string)

    result_words = ""
    # 第x話 と一致する。(exclude:"畳間"")
    morph[:raw].each_with_index do |item , index|
      if @@pass_list.include?(words_raw[index+1]) then
        next
      end

      is_same = %w[冠数詞 Number 助数詞] <=> words[:morph][index, 3]
      if is_same != nil && is_same == 0 then
        words[:raw].slice!(index, 3)
        words[:morph].slice!(index, 3)
        words[:kana].slice!(index, 3)
      end
    end

    # x話 と一致する。
    words_morph.each_with_index do |item , index|
      if @@pass_list.include?(words_raw[index+1]) then
        next
      end
      
      is_same = %w[Number 助数詞] <=> words_morph[index, 2]
      if is_same != nil && is_same == 0 then
        words_raw.slice!(index, 2)
        words_morph.slice!(index, 2)
        words_kana.slice!(index, 2)
      end
    end

    words_morph.each_with_index do |word, index|
      case words_raw[index]
      when *@@pass_list
        result_words << words_raw[index]
        next
      end

      case word
      when *%w[名詞 Alphabet Number Kana Kanji 名詞接尾辞 Katakana 格助詞 動詞語幹 動詞接尾辞]
        result_words << words_raw[index]
      when *%w[Symbol 括弧 空白 句点]
      else
        puts "Error  " << word << " " << words_raw[index]
        err = Error.create(:name => "morph", :description => word.to_s)
        puts err.to_s
      end
    end

    return result_words
  end


  def analyze_pattern(target_string)

  end
end
