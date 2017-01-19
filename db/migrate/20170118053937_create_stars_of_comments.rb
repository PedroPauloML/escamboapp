class CreateStarsOfComments < ActiveRecord::Migration[5.0]
  def change
    create_table :stars_of_comments do |t|
      t.float :stars5
      t.float :stars4
      t.float :stars3
      t.float :stars2
      t.float :stars1

      t.timestamps
    end
  end
end
