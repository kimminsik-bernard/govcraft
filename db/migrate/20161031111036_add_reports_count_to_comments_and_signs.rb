class AddReportsCountToCommentsAndSigns < ActiveRecord::Migration[5.0]
  def change
    add_column :comments, :reports_count, :integer, default: 0
    add_column :signs, :reports_count, :integer, default: 0
  end
end
