class CreateFollowingIssues < ActiveRecord::Migration[5.0]
  def change
    create_table :following_issues do |t|
      t.references :issue, null: false, index: true
      t.references :user, null: false, index: true
      t.timestamps null: false
    end

    add_index :following_issues, [:issue_id, :user_id], unique: true
  end
end
