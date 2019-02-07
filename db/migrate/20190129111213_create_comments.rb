class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |table|
      table.string :body, null: false, length: { maximum: 3000 }
      table.references :user, index: true, foreign_key: true, null: false
      table.references :meetup, index: true, foreign_key: true, null: false
      table.timestamps null: false
    end
  end
end
