class AddTotalStarsToStarsOfComment < ActiveRecord::Migration[5.0]
  def change
    add_column :stars_of_comments, :totalStars, :float
  end
end
