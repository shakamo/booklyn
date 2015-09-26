class CreatePhantomJs < ActiveRecord::Migration
  def change
    create_table :phantom_js, &:timestamps
  end
end
