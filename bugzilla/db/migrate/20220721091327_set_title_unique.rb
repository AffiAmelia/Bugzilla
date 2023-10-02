# frozen_string_literal: true

class SetTitleUnique < ActiveRecord::Migration[5.2]
  def change
    change_table :bugs, bulk: true do |t|
      t.remove_index :title
      t.index %i[title project_id], unique: true
    end
  end
end
