class CreateSolicitudes < ActiveRecord::Migration[6.1]
  def change
    create_table :solicitudes do |t|
      t.date :fecha
      t.string :status
      t.string :tracking_number

      t.timestamps
    end
  end
end
