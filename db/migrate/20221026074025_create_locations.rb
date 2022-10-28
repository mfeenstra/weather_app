class CreateLocations < ActiveRecord::Migration[7.0]
  def change
    create_table :locations do |t|
      t.string :zipcode
      t.string :street
      t.string :city
      t.string :country_code
      t.decimal :lat
      t.decimal :long

      t.timestamps
    end
    add_index :locations, :zipcode
  end
end
