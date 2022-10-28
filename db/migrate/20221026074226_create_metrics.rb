class CreateMetrics < ActiveRecord::Migration[7.0]
  def change
    create_table :metrics do |t|
      t.integer :location_id
      t.string :zipcode
      t.decimal :temp
      t.decimal :min
      t.decimal :max
      t.integer :day

      t.timestamps
    end
    add_index :metrics, :location_id
    add_index :metrics, :zipcode
  end
end
