class CreateApiOfferDepartments < ActiveRecord::Migration[6.1]
  def change
    create_table :api_offer_departments do |t|
      t.references :api_offer, null: false, foreign_key: true
      t.references :department, null: false, foreign_key: true
    end
  end
end
