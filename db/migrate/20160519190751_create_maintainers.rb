class CreateMaintainers < ActiveRecord::Migration[5.0]
  def change
    create_table :maintainers do |t|
      t.string :name
      t.string :email

      t.timestamps
    end

    add_index :maintainers, :email, unique: true
  end
end
