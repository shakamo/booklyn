# == Schema Information
#
# Table name: term_frequencies
#
#  id         :integer          not null, primary key
#  content_id :integer
#  word       :string
#  created_at :datetime
#  updated_at :datetime
#
# Indexes
#
#  index_term_frequencies_on_content_id  (content_id)
#

require 'goo_labs'

#
class TermFrequency < ActiveRecord::Base
  belongs_to :content

  class << self
    include GooLabs

    def execute
      TermFrequency.register
    end

    def register
      new_term_frequencies = []

      search.each do |item|
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
    handle_asynchronously :register

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
end
