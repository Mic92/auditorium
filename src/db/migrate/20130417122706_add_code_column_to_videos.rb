class AddCodeColumnToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :code, :string
  end
end
