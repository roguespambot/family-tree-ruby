class AddFieldsToPeople < ActiveRecord::Migration
  def change
    add_column :people, :parent1_id, :int
    add_column :people, :parent2_id, :int
    add_column :people, :gender, :string
  end
end
