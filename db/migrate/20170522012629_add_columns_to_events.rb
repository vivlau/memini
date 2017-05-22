class AddColumnsToEvents < ActiveRecord::Migration[5.0]
  def change
    add_column :events, :search_term, :string
    add_column :events, :name, :string
    add_column :events, :images, :string
    add_column :events, :rating, :string
    add_column :events, :reviews, :string
    add_column :events, :coordinates, :string
    add_column :events, :address, :string
    add_column :events, :phone, :string
    add_column :events, :price, :string
    add_column :events, :hours, :string
  end
end
