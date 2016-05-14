class AddDefaultToGroupEvent < ActiveRecord::Migration
  def change
    change_column :group_events, :active, :boolean, default: true
  end
end
