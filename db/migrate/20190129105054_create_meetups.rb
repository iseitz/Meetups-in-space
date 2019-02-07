class CreateMeetups < ActiveRecord::Migration
  def change
    create_table :meetups do |table|
      table.string :title, null: false
      table.string :theme, null: false
      table.datetime :date, null: false
      table.datetime :begin_time, null: false
      table.datetime :end_time, null: false
      table.string :location, null: false
      table.string :description, null: false
      table.references :user, index: true, foreign_key: true, null: false

      table.timestamps null: false
    end
  end
end
