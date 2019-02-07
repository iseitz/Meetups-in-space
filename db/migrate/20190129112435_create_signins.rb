class CreateSignins < ActiveRecord::Migration
  def change
    create_table :signings do |table|
      table.datetime :date, null: false
      table.belongs_to :user, null: false
      table.belongs_to :provider, null: false
      table.timestamps null: false
    end
  end
end
