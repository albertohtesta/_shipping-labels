class CreateShippings < ActiveRecord::Migration[6.1]
  def change
    create_table :shippings do |t|
      t.string :Shipping
      t.belongs_to :carrier, null: false, foreign_key: true
      t.belongs_to :solicitude, null: false, foreign_key: true
      t.string :name_from
      t.string :street_from
      t.string :city_from
      t.string :province_from
      t.string :postal_code_from
      t.string :countr_code_from
      t.string :name_to
      t.string :street_to
      t.string :city_to
      t.string :province_to
      t.string :postal_code_to
      t.string :countr_code_to
      t.integer :length
      t.integer :width
      t.integer :height
      t.string :dimensions_unit
      t.integer :weight
      t.string :weight_unit
      t.string :status
      t.string :shipment_id
      t.string :label_url
      t.string :id_response
      t.string :tracking_number

      t.timestamps
    end
  end
end
