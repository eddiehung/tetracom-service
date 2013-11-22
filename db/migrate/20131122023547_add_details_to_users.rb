class AddDetailsToUsers < ActiveRecord::Migration
  def change
	  add_column :users, :phone, :string
	  add_column :users, :affiliation, :string
	  add_column :users, :expertise, :string
  end
end
