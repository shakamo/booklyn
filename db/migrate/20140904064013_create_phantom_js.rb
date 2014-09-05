class CreatePhantomJs < ActiveRecord::Migration
  def change
    create_table :phantom_js do |t|

      t.timestamps
    end
  end
end
