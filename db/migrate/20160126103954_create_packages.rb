class CreatePackages < ActiveRecord::Migration
  def change
    create_table :packages do |t|
      t.string :name
      t.string :version
      t.datetime :date_publication
      t.string :title
      t.string :description

      t.timestamps null: false
    end

    add_index :packages, [:name, :version]
  end
end
