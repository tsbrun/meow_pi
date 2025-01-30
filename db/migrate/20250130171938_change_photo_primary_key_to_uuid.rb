class ChangePhotoPrimaryKeyToUuid < ActiveRecord::Migration[7.1]
  def change
    remove_column :photos, :id
    add_column :photos, :id, :uuid, default: 'gen_random_uuid()', null: false
    execute "ALTER TABLE photos ADD PRIMARY KEY (id);"

    # Update foreign keys that reference the id column in the photos table
    foreign_keys = ActiveRecord::Base.connection.foreign_keys(:photos)
    foreign_keys.each do |fk|
      remove_foreign_key fk.from_table, name: fk.name
      add_foreign_key fk.from_table, :photos, column: fk.options[:column], primary_key: :id
    end
  end
end
