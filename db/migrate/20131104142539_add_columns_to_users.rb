class AddColumnsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :provider, :string
    add_column :users, :uid, :string
    add_column :users, :name, :string
    add_column :users, :last_name, :string
    add_column :users, :facebook_photo_url, :string
    add_column :users, :birth_date, :date
    add_column :users, :mobile_phone, :string
    add_column :users, :address, :string
    add_column :users, :validation_status, :integer, :default => 0
  end
end
