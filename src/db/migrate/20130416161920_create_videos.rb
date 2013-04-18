class CreateVideos < ActiveRecord::Migration
  def change
    create_table :videos do |t|
      t.string :title
      t.text :description
      t.integer :course_id
      t.string :uri

      t.timestamps
    end
  end
end
