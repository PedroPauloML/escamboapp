class AddAveragesToStarsOfComment < ActiveRecord::Migration[5.0]
  def change
    add_column :stars_of_comments, :average_stars5, :float
    add_column :stars_of_comments, :average_stars4, :float
    add_column :stars_of_comments, :average_stars3, :float
    add_column :stars_of_comments, :average_stars2, :float
    add_column :stars_of_comments, :average_stars1, :float
  end
end
