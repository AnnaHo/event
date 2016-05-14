class AddColumnActiveToGroupEvent < ActiveRecord::Migration
  def change
    add_column :group_events, :active, :boolean
  end
end
