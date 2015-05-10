require 'active_support/concern'
require 'net/http'
require 'uri'

# GooLabs API を呼び出す
module GooLabs
  extend ActiveSupport::Concern
  include UrlUtils

  API_KEY = '9f44e0022e49a2414c19d0689a687c44b0e85d603219e4f7042b6d57a668d678'
  GOO_LAB_URI = 'https://labs.goo.ne.jp/api/morph'

  def call_morph(target_string)
    body = post_body_ssl(GOO_LAB_URI, { app_id: API_KEY, sentence: target_string })
    load_morph_array(body)
  end

  def load_morph_array(json)
    json = JSON.parse(json, symbolize_names: true)

    morph = { raw: [], morph: [], kana: [] }

    json[:word_list].each do |word_list|
      word_list.each do |word|
        morph[:raw] << word[0]
        morph[:morph] << word[1]
        morph[:kana] << word[2]
      end
    end
    morph
  end

  module_function :call_morph
  module_function :load_morph_array
end
