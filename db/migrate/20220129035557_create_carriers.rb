class CreateCarriers < ActiveRecord::Migration[6.1]
  def change
    create_table :carriers do |t|
      t.string :name
      t.string :endpoint
      t.string :token

      t.timestamps
    end
  end
end
