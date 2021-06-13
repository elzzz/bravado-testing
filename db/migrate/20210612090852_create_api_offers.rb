class CreateApiOffers < ActiveRecord::Migration[6.1]
  def change
    create_table :api_offers do |t|
      t.datetime :created_at, :default => Time.now.utc
      t.decimal :price
      t.string :company, null: true
      t.index :company
    end
  end
end
