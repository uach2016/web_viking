class AddMarketGooIdToshops < ActiveRecord::Migration[5.0]
  def change
  	add_column :shops, :market_goo_id, :string, unique: true
  end
end
