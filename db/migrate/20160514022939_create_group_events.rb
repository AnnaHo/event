class CreateGroupEvents < ActiveRecord::Migration
  def change
    create_table :group_events do |t|
      t.string :name
      t.text :description
      t.string :location
      t.datetime :start_date
      t.datetime :end_date
      t.string :status
      t.timestamps
    end
  end
end
