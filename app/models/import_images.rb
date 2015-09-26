
require 'net/https'
require 'json'

# コンテンツの一覧を取得するクラス
#   アニメやドラマのタイトル、放送日などを取得する。
#   アニメやドラマのタイトル、放送日などを取得する。
class ImportImages
  # Contentを取得して、データベースに格納する。
  # @param site_name [String] Contentを取得するサイトを指定する。Anikore, Rakuten
  # @param year [String] Contentを取得する範囲を指定する。Anikore のみ。2015
  # @param season [String] Contentを取得するシーズンを指定する。winter, spring, summer, autumn
  def perform_all(_site_name, year, season)
    Video::Anikore.new.import_all(year, season)
  end
end
