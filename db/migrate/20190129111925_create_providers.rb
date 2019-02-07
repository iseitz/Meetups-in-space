class CreateProviders < ActiveRecord::Migration
  def change
    create_table :providers do |table|
      table.string :name, null: false
      table.timestamps null: false
    end
  end
end
