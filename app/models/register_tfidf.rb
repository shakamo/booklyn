
# 
class RegisterTfidf
  include GooLabs

  def execute
    search.each_slice(10) do |items|
      register(items.to_a)
    end
  end

  def register(items)
    puts items.to_s
    new_term_frequencies = []

    items.each do |item|
      morph = call_morph(item['title'])

      morph[:raw].each do |word|
        tf = TermFrequency.new
        tf.content_id = item['id']
        tf.word = word

        new_term_frequencies << tf
      end

      if 1000 < new_term_frequencies.size
        TermFrequency.import new_term_frequencies
        new_term_frequencies = []
      end
    end

    TermFrequency.import new_term_frequencies
  end
  handle_asynchronously :register, queue: :tfidf_register

  def search
    sql = <<-SQL
    SELECT
      C.ID       AS ID
      , C.TITLE  AS TITLE
    FROM
      CONTENTS C
    WHERE
      NOT EXISTS(
        SELECT
          *
        FROM
          TERM_FREQUENCIES TF
        WHERE
          TF.CONTENT_ID = C.ID
      )
    SQL
    ActiveRecord::Base.connection.select_all(sql)
  end
end