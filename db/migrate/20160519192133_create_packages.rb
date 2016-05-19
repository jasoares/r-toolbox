class CreatePackages < ActiveRecord::Migration[5.0]
  def change
    create_table :packages do |t|
      t.string :name

      t.timestamps
    end

    add_index :packages, :name, unique: true
  end
end
