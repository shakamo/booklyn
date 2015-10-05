
require 'net/https'
require 'json'

# コンテンツの一覧を取得するクラス
#   アニメやドラマのタイトル、放送日などを取得する。
#   アニメやドラマのタイトル、放送日などを取得する。
class ImportContents
  include TfIdf

  # Contentを取得して、データベースに格納する。
  # @param site_name [String] Contentを取得するサイトを指定する。Anikore, Rakuten
  # @param year [String] Contentを取得する範囲を指定する。Anikore のみ。2015
  # @param season [String] Contentを取得するシーズンを指定する。winter, spring, summer, autumn
  def perform_all(site_name, year, season, days = 3)
    begin
      case site_name
      when :Anikore
        Video::Anikore.new.import_tv(year, season)
        Video::Anikore.new.import_movie(year, season)
      when :Rakuten
        Video::Rakuten.new.import_all(year, season)
      when :Shoboi
        Video::Shoboi.new.import_all(days)
      else
        fail 'ImportContents 呼び出しが不正です。' << site_name.to_s << year.to_s << season.to_s
      end
    rescue => e
      raise(StandardError, e.message + '!!', e.backtrace)
    end
  end
  handle_asynchronously :perform_all, queue: :perform_content
end
