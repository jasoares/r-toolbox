class CreateVersions < ActiveRecord::Migration[5.0]
  def change
    create_table :versions do |t|
      t.string :value
      t.datetime :publication
      t.string :title
      t.string :description
      t.string :authors
      t.references :maintainer, foreign_key: true
      t.references :package, foreign_key: true

      t.timestamps
    end

    add_index :versions, [:package_id, :value], unique: true
  end
end
