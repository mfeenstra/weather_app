class AddDtToMetric < ActiveRecord::Migration[7.0]
  def change
    add_column :metrics, :dt, :integer
    rename_column :metrics, :day, :period
  end
end
