require 'active_support/concern'

module TfIdf
  extend ActiveSupport::Concern

  class Item < Struct.new(:word, :tfidf)
  end

  def insert_tfidf
    contents = Content.all.to_a.each do |content|
      puts content.title

      json = GooLabs.call_morph(content.title)

      json["word_list"].each do |item|
        item.each do |word|
          puts word[0]

          tf = TermFrequency.find_or_initialize_by(content_id: content.id, word: word[0])
          tf.save
        end
      end
    end
  end


  def get_tfidf(title)

    json = GooLabs.call_morph(title)

    items = Array.new
    wordSet = Set.new

    json["word_list"].each do |words|
      words.each do |word|
        tfidf = ActiveRecord::Base.connection.select_rows("SELECT CASE WHEN WORD <> 0 THEN LOG(DOCUMENT/WORD::DECIMAL)+1 ELSE 0 END AS IDF FROM (SELECT COUNT(A.X) AS WORD FROM (SELECT COUNT(*) AS X FROM TERM_FREQUENCIES WHERE WORD = '" + word[0] + "' GROUP BY CONTENT_ID) AS A) AS AA ,(SELECT COUNT(B.X) AS DOCUMENT FROM (SELECT COUNT(CONTENT_ID) AS X FROM TERM_FREQUENCIES GROUP BY CONTENT_ID) AS B) AS BB")[0][0].to_f

        items << Item.new(word[0], tfidf)

        if 2.3 < tfidf then
          wordSet << word[0]
        end
      end
    end
    items = items.sort do |left, right| 
      right.tfidf <=> left.tfidf
    end

    contentSet = Set.new
    items.each do |item|
      contents = TermFrequency.where(word: item.word)

      currentSet = Set.new
      contents.each do |content|
        currentSet << content.content_id
      end

      if contentSet.size == 0 then
        currentSet.each do |item|
          contentSet << item
        end
      else
        contentSet = contentSet & currentSet
      end

      if contentSet.size == 1 then
        word_count = TermFrequency.where(word: wordSet.to_a, content_id: contentSet.first).group(:word).count.size

        if wordSet.size*0.8 < word_count && word_count <= wordSet.size then
          return contentSet.first
        end
        return nil
      end
    end
    return nil
  end
end
