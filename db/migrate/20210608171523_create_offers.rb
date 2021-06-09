class CreateOffers < ActiveRecord::Migration[6.1]
  def change
    create_table :offers do |t|
      t.datetime :created_at, :default => Time.now.utc
      t.decimal :price
      t.string :company
    end
  end
end
