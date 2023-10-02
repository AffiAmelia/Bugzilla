# frozen_string_literal: true

class CreateBugs < ActiveRecord::Migration[5.2]
  def change
    create_table :bugs do |t|
      t.string :title, null: false
      t.index :title, unique: true
      t.integer :category, null: false, default: 0
      t.string :description
      t.integer :status, null: false, default: 0
      t.datetime :deadline, null: false
      t.references :creator, index: true, foreign_key: { to_table: :users, on_delete: :cascade }
      t.references :assignee, index: true, foreign_key: { to_table: :users }
      t.references :project, index: true, foreign_key: { on_delete: :cascade }

      t.timestamps
    end
  end
end
