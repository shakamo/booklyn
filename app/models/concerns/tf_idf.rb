require 'active_support/concern'

# TF-IDF Algorithm
module TfIdf
  extend ActiveSupport::Concern
  include GooLabs

  def get_tfidf(morph)
    words = []
    morph[:raw].each do |word|
      words << word.gsub("'", "''")
    end

    words_for_in = "'" + words.join("','") + "'"

    sql = <<-SQL
      SELECT
        CONTENT_ID
        , ROUND(SUM(TFIDF), 3) AS TFIDF
      FROM
        (
          SELECT
            RELN.CONTENT_ID AS CONTENT_ID
            , IDF.IDF * TF.TF AS TFIDF
          FROM
            (
              SELECT
                LOG(
                  10
                  , (SELECT COUNT(*) AS TOTAL FROM CONTENTS) / COUNT(*)
                ) + 1 AS IDF
                , TF.WORD
              FROM
                TERM_FREQUENCIES TF
              WHERE
                TF.WORD IN (#{words_for_in})
              GROUP BY
                TF.WORD
            ) IDF
            LEFT OUTER JOIN (
              SELECT
                WORD
                , CONTENT_ID
              FROM
                TERM_FREQUENCIES
              GROUP BY
                WORD
                , CONTENT_ID
            ) AS RELN
              ON (IDF.WORD = RELN.WORD)
            LEFT OUTER JOIN (
              SELECT
                CONTENT_ID
                , 1.0 / COUNT(*) AS TF
              FROM
                TERM_FREQUENCIES
              GROUP BY
                CONTENT_ID
            ) AS TF
              ON (RELN.CONTENT_ID = TF.CONTENT_ID)
        ) AS A
      GROUP BY
        CONTENT_ID
      ORDER BY
        SUM(TFIDF) DESC
    SQL

    tfidf = ActiveRecord::Base.connection.select_all(sql).select do |item|
      Settings.tfidf <= item['tfidf'].to_f
    end
    return tfidf[0] if tfidf.is_a?(Array)
    tfidf
  end
end
