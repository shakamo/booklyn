require 'active_support/concern'
require 'net/http'
require 'uri'

# GooLabs API を呼び出す
module GooLabs
  extend ActiveSupport::Concern
  include UrlUtils

  def call_morph(target_string)
    body = post_body_ssl(Settings.goo.url, app_id: get_api_key, sentence: target_string)

    if body.blank?
      Rails.application.config.goo_api_key_num += 1
      call_morph(target_string)
    else
      load_morph_array(body)
    end
  end

  def load_morph_array(body)
    json = JSON.parse(body, symbolize_names: true)
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

  def get_api_key
    if Rails.application.config.goo_api_key_num == 1
      Settings.goo.api_key_1
    elsif Rails.application.config.goo_api_key_num == 2
      Settings.goo.api_key_2
    elsif Rails.application.config.goo_api_key_num == 3
      Settings.goo.api_key_3
    elsif Rails.application.config.goo_api_key_num == 4
      Settings.goo.api_key_4
    else
      fail 'Goo API Key Error'
    end
  end

  module_function :call_morph
  module_function :load_morph_array
end
