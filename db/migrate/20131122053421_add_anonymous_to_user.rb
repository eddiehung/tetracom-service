class AddAnonymousToUser < ActiveRecord::Migration
  def change
    add_column :users, :show_name, :boolean
    add_column :users, :show_email, :boolean
    add_column :users, :show_phone, :boolean
    add_column :users, :show_affiliation, :boolean
  end
end
