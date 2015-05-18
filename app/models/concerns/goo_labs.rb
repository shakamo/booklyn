require 'active_support/concern'
require 'net/http'
require 'uri'

# GooLabs API を呼び出す
module GooLabs
  extend ActiveSupport::Concern
  include UrlUtils

  def call_morph(target_string)
    body = post_body_ssl(Settings.goo.url, app_id: Settings.goo.api_key, sentence: target_string)
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
