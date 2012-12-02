class CreateFlowers < ActiveRecord::Migration
  def change
    create_table :flowers do |t|
      t.string :name
      t.string :cosmId

      t.timestamps
    end
  end
end
