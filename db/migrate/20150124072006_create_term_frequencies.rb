class CreateTermFrequencies < ActiveRecord::Migration
  def change
    create_table :term_frequencies do |t|
      t.references :content, index: true
      t.string :word

      t.timestamps
    end
  end
end
