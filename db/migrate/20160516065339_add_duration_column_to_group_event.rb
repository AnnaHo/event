class AddDurationColumnToGroupEvent < ActiveRecord::Migration
  def change
    add_column :group_events, :duration, :integer
  end
end
