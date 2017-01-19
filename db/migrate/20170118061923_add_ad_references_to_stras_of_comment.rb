class AddAdReferencesToStrasOfComment < ActiveRecord::Migration[5.0]
  def change
    add_reference :stars_of_comments, :ad, foreign_key: true
  end
end
