class RenameDtColumn < ActiveRecord::Migration[7.0]
  def change
    # best to just use the given DateTime (text) field for the period
    remove_column :metrics, :dt
    add_column :metrics, :dt_txt, :datetime
  end
end
