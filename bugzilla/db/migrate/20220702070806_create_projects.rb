# frozen_string_literal: true

class CreateProjects < ActiveRecord::Migration[5.2]
  def change
    create_table :projects do |t|
      t.string :title, null: false
      t.string :description
      t.index :title, unique: true
      t.references :creator, index: true, foreign_key: { to_table: :users, on_delete: :cascade }

      t.timestamps
    end
  end
end
