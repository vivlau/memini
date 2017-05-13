class AddOmniauthRawDataToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :omniauth_raw_data, :string
  end
end
