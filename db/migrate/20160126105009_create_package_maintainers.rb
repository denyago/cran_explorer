class CreatePackageMaintainers < ActiveRecord::Migration
  def change
    create_table :package_maintainers do |t|
      t.references :package
      t.references :person

      t.timestamps null: false
    end
  end
end
