class AddFromCacheToMetric < ActiveRecord::Migration[7.0]
  def change
    # although a nil boolean seems to be frowned upon, it works quite well in this paradigm
    add_column :metrics, :from_cache, :boolean, null: true, default: nil
  end
end
