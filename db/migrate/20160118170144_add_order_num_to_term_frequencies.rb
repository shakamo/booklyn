class AddOrderNumToTermFrequencies < ActiveRecord::Migration
  def change
    add_column :term_frequencies, :order_num, :integer
  end
end
